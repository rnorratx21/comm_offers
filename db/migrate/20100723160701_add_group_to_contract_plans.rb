class AddGroupToContractPlans < ActiveRecord::Migration
  def self.up
    add_column :contract_plans, :group_id, :integer
  end

  def self.down
    remove_column :contract_plans, :group_id
  end
end