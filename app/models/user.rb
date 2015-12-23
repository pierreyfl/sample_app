class User < ActiveRecord::Base
  include HasActivities

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :active_relationships, class_name: Relationship, foreign_key: 'follower_id', dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: Relationship, foreign_key: 'followed_id', dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :microposts

  validates :type, inclusion: { in: ['Author', 'Admin'] }, allow_nil: true
  
  def feed
    if admin?
      Micropost.all
    else
      Micropost.where(user_id: following_ids)
    end
  end

  def unviewed_notifications
    notifications.where(viewed: false)
  end

  def latest_notifications
    unviewed = unviewed_notifications.limit(10)
    
    if unviewed.count < 10
      remaining_count = 10 - unviewed.count
      unviewed += notifications.where(viewed: true).limit(remaining_count)
    end

    unviewed
  end
  
  def author?
    type == 'Author'
  end

  def admin?
    type == 'Admin'
  end

  def user?
    type.nil?
  end

  def follow!(user)
    unless followed?(user)
      if relationship = active_relationships.create(followed: user)
        PublicActivity::Activity.create(trackable: relationship, 
                                        owner: self, 
                                        recipient: user,
                                        key: 'relationship.create')
      end
    end
  end

  def unfollow!(user)
    active_relationships.where(followed: user).destroy_all if followed?(user)
  end

  def followed?(user)
    following.exists?(id: user.id)
  end

  def followable?(current_user)
    !(self == current_user) && author? && !current_user.author?
  end
end
