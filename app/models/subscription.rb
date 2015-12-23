class Subscription < ActiveRecord::Base
  belongs_to :author, class_name: Author
  belongs_to :subscriber, class_name: User

  validates :subscriber_id, uniqueness: { scope: [:author_id] }
  
  def paid?
    payment_status == 'paid'
  end
end
