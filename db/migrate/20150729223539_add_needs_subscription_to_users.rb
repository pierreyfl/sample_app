class AddNeedsSubscriptionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :needs_subscription, :boolean
  end
end
