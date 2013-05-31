class AddPaymentBypassCodeForGoldContractPlan < ActiveRecord::Migration
  def self.up
    ContractPlan.reset_column_information
    gold = ContractPlan.find_by_system_key("gold")
    gold.payment_bypass_code = "co-gold"
    gold.save
  end

  def self.down
  end
end
