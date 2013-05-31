class AddAcceptedPaymentTypesToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :accepted_payment_types, :string
  end

  def self.down
    remove_column :offers, :accepted_payment_types
  end
end
