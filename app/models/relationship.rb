class Relationship < ActiveRecord::Base
  belongs_to :follower, class_name: User
  belongs_to :followed, class_name: User

  validates :follower_id, :followed_id, presence: true
  validates :follower_id, uniqueness: { scope: :followed_id }
  validate  :user_types, if: -> { followed.present? && follower.present? }

private

  def user_types
    unless followed.author? && follower.user?
      errors.add :base, 'User can only follow authors'
    end
  end

end
