class CreateGroupContractPlans < ActiveRecord::Migration
  def self.up
    create_table :group_contract_plans do |t|
      t.integer :contract_plan_id
      t.integer :group_id
      t.decimal :price
      t.timestamps
    end
  end

  def self.down
    drop_table :group_contract_plans
  end
end
