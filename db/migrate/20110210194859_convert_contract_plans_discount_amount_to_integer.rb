class ConvertContractPlansDiscountAmountToInteger < ActiveRecord::Migration
  def self.up
    change_column :contract_plans, :discount_amount, :decimal, :allow_nil => false
  end

  def self.down
    change_column :contract_plans, :discount_amount, :decimal, :allow_nil => true
  end
end
