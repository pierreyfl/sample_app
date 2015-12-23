class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :author_id
      t.integer :subscriber_id
      t.string :paypal_pay_key
      t.string :payment_status

      t.timestamps null: false
    end

    add_index :subscriptions, :author_id
    add_index :subscriptions, :subscriber_id
  end
end
