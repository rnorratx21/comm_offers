class Addresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :phone_number
      t.float :lat
      t.float :lng      
      t.timestamps
    end
  end
  
  def self.down
    drop_table :addresses
  end
end
