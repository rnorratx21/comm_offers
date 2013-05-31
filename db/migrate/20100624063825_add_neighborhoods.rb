class AddNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :neighborhoods do |t|
      t.string :name, :null => false
      t.string :city, :null => false
      t.string :state, :null => false, :size => 2
      t.float :lat, :null => false
      t.float :lng, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :neighborhoods
  end
end