class Author < User
  has_many :subscriptions

  def subscribed?(user)
    subscription = subscriptions.where(subscriber: user).first
    subscription.present? ? subscription.paid? : false
  end

  def subscription_setup?
    needs_subscription? && paypal_email.present?
  end

  def subscription_fee
    read_attribute(:subscription_fee) || 5.0
  end
end
