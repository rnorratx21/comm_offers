class CreateContractFeatures < ActiveRecord::Migration
  def self.up
    create_table :contract_features do |t|
      t.integer :contract_id
      t.integer :feature_id

      t.timestamps
    end
  end

  def self.down
    drop_table :contract_features
  end
end
