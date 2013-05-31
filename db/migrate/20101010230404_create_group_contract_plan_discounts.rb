class CreateGroupContractPlanDiscounts < ActiveRecord::Migration
  def self.up
    create_table :group_contract_plan_discounts do |t|
      t.integer :group_contract_plan_id
      t.integer :discount_id
      t.timestamps
    end
  end

  def self.down
    drop_table :group_contract_plan_discounts
  end
end
