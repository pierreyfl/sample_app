require 'rails_helper'

describe Subscription do

  describe :validations do
    it 'checks the uniqueness of subscriber to author' do
      Subscription.create!
      subscription = Subscription.new
      subscription.save
      expect(subscription.errors.full_messages).to include 'Subscriber has already been taken'
    end
  end

  describe '#paid?' do
    it 'returns true if the payment has been paid' do
      subscription = Subscription.new payment_status: 'paid'

      expect(subscription.paid?).to eq true
    end
  end
end
