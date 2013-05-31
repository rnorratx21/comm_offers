class ConvertIsPlatinumToContractPlan < ActiveRecord::Migration
  def self.up
    gold_plan = ContractPlan.find_by_system_key "gold"
    platinum_plan = ContractPlan.find_by_system_key "platinum"

    Contract.all(:conditions => {:platinum => true}).each do |c|
      c.update_attributes(:contract_plan => platinum_plan)
    end

    Contract.all(:conditions => {:platinum => false}).each do |c|
      c.update_attributes(:contract_plan => gold_plan)
    end
  end

  def self.down
  end
end
