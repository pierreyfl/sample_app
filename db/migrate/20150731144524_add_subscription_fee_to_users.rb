class AddSubscriptionFeeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subscription_fee, :float
  end
end
