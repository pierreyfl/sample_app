class AddPaypalEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paypal_email, :string
    add_column :users, :paypal_token, :string
    add_column :users, :paypal_token_secret, :string
    add_column :users, :paypal_scope, :string
  end
end
