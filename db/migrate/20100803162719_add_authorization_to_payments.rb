class AddAuthorizationToPayments < ActiveRecord::Migration
  def self.up
    add_column :ledger_items, :authorization, :string
    add_column :ledger_items, :response, :text
  end

  def self.down
    remove_column :ledger_items, :response
    remove_column :ledger_items, :authorization
  end
end
