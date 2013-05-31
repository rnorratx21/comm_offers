class AddPaymentDetailsToLedgerItem < ActiveRecord::Migration
  def self.up
    add_column :ledger_items, :check_number, :string
    add_column :ledger_items, :check_date, :date
  end

  def self.down
    remove_column :ledger_items, :check_date
    remove_column :ledger_items, :check_number
  end
end
