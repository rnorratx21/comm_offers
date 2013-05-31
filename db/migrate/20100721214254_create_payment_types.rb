class CreatePaymentTypes < ActiveRecord::Migration
  def self.up
    
    add_column :ledger_items, :payment_type_id, :integer
    create_table :payment_types do |t|
      t.string :name

      t.timestamps
    end
    
    PaymentType.create(:name => "Credit Card")
    PaymentType.create(:name => "Check")
    PaymentType.create(:name => "ACH")
    PaymentType.create(:name => "Cash")
    PaymentType.create(:name => "Other")
  end

  def self.down
    remove_column :ledger_items, :payment_type_id
    drop_table :payment_types
  end
end
