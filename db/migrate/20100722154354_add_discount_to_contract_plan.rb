class AddDiscountToContractPlan < ActiveRecord::Migration
  def self.up
    add_column :contract_plans, :discount_amount, :decimal, :default => 0
  end

  def self.down
    remove_column :contract_plans, :discount_amount
  end
end
