class Transactions < ActiveRecord::Migration
  def self.up
    create_table :transactions do |t|
      t.integer :offer_id
      t.datetime :transaction_at
      t.string :response
      t.string :invoice_type
      t.float :amount
      t.text :params
      t.timestamps
    end
  end

  def self.down
    drop_table :transactions
  end
end
