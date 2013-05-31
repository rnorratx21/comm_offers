class ZipCodes < ActiveRecord::Migration
  def self.up
    create_table :zip_codes do |t|
      t.string :zip_code
      t.string :city
      t.string :state
      t.float :lat
      t.float :lng
      t.timestamps
    end
  end

  def self.down
    drop_table :zip_codes
  end
end
