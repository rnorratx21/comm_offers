class AddSystemKeyAndIsActiveToContractPlans < ActiveRecord::Migration
  def self.up
    add_column :contract_plans, :system_key, :string
    add_column :contract_plans, :is_active, :boolean, :default => false

    ContractPlan.find_by_name("Gold Plan").update_attributes(:system_key => "gold", :is_active => true)
    ContractPlan.find_by_name("Platinum Plan").update_attributes(:system_key => "platinum", :is_active => true)
  end

  def self.down
    remove_column :contract_plans, :system_key
    remove_column :contract_plans, :is_active
  end
end
