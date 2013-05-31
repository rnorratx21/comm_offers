class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.integer :offer_id
      t.string :code
      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
