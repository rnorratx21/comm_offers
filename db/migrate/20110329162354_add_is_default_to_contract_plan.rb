class AddIsDefaultToContractPlan < ActiveRecord::Migration
  def self.up
    add_column :contract_plans, :is_default, :boolean
    ContractPlan::GOLD.update_attributes(:is_default => true)
  end

  def self.down
    remove_column :contract_plans, :is_default
  end
end
