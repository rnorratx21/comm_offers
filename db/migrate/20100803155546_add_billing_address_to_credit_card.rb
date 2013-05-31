class AddBillingAddressToCreditCard < ActiveRecord::Migration
  def self.up
    change_table :credit_cards do |t|
      t.string :address1, :address2, :city, :state, :zip, :country, :phone, :email, :authorization
    end
  end

  def self.down
    change_table :credit_cards do |t|
      t.remove :address1, :address2, :city, :state, :zip, :country, :phone, :email, :authorization
    end
  end
end
