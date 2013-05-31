class CreateBillingCreditCards < ActiveRecord::Migration
  def self.up
    create_table :credit_cards do |t|
      t.integer :contract_id
      t.string :billing_token, :first_name, :last_name, :display_number, :month, :year, :zip_code
      t.date :expires_on
      t.timestamps
    end
  end

  def self.down
    drop_table :credit_cards
  end
end
