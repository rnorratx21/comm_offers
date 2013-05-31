class CreateDirectoryListings < ActiveRecord::Migration
  def self.up
    create_table :directory_listings do |t|
      t.string :name
      t.integer :address_id
      t.string :phone_number
      t.timestamps
    end
  end

  def self.down
    drop_table :directory_listings
  end
end
