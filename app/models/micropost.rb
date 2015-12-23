class Micropost < ActiveRecord::Base
  validates :user, :content, presence: true
  validate  :user_type, if: -> { user.present? }

  belongs_to :user
  
  default_scope -> { order('created_at DESC') }

private
  def user_type
    unless user.author? || user.admin?
      errors.add(:user, 'cannot create post')
    end
  end
end
