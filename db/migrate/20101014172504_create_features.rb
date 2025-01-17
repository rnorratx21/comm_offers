class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.string :title
      t.string :description
      t.decimal :amount
      t.string :system_key
      t.timestamps
    end
  end

  def self.down
    drop_table :features
  end
end
