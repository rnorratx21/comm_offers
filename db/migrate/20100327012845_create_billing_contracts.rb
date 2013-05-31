class CreateBillingContracts < ActiveRecord::Migration
  def self.up
    
    create_table :contracts, :force => true do |t|
      t.integer :advertiser_id
      t.timestamps
    end
    
    add_column :offers, :contract_id, :integer
    add_column :ledger_items, :contract_id, :integer
    add_column :ledger_items, :ledger_item_id, :integer
  end

  def self.down
    drop_table :contracts
    remove_column :offers, :contract_id
    remove_column :ledger_items, :contract_id
    remove_column :ledger_items, :ledger_item_id
  end
end
