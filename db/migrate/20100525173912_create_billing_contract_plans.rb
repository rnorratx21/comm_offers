class CreateBillingContractPlans < ActiveRecord::Migration
  def self.up
    rename_table :plans, :cheddar_getter_plans
    create_table :contract_plans do |t|
      t.string :name, :period
      t.integer :due_on_day, :start_after
      t.integer :tax_rate
      t.decimal :installment_amount, :setup_amount
      t.integer :installments

      t.timestamps
    end
  end

  def self.down
    rename_table :cheddar_getter_plans, :plans
    drop_table :contract_plans
  end
end
