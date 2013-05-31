class AddPaymentBypassCodeToContractPlans < ActiveRecord::Migration
  def self.up
    add_column :contract_plans, :payment_bypass_code, :string
  end

  def self.down
    remove_column :contract_plans, :payment_bypass_code
  end
end
