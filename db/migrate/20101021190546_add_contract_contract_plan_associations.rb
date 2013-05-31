class AddContractContractPlanAssociations < ActiveRecord::Migration
  def self.up
    add_column :contracts, :contract_plan_id, :integer
    add_column :contracts, :group_contract_plan_id, :integer
    
  end

  def self.down
    drop_column :contracts, :contract_plan_id
    drop_column :contracts, :group_contract_plan_id
  end
end
