class CreateSalesAreas < ActiveRecord::Migration
  def self.up
    create_table :sales_areas do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :sales_areas
  end
end
