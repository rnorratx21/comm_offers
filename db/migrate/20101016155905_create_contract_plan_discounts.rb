class CreateContractPlanDiscounts < ActiveRecord::Migration
  def self.up
    create_table :contract_plan_discounts do |t|
      t.integer :contract_plan_id
      t.integer :discount_id
      t.timestamps
    end
  end

  def self.down
    drop_table :contract_plan_discounts
  end
end
