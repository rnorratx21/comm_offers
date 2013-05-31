class CreateContractPlanFeatures < ActiveRecord::Migration
  def self.up
    create_table :contract_plan_features do |t|
      t.integer :contract_plan_id
      t.integer :feature_id
      t.boolean :addon
      t.decimal :amount
      t.integer :quantity
      t.timestamps
    end
  end

  def self.down
    drop_table :contract_plan_features
  end
end
