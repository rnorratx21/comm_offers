class CreateSalesAreaZipCodes < ActiveRecord::Migration
  def self.up
    create_table :sales_area_zip_codes do |t|
      t.integer :sales_area_id
      t.integer :zip_code_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sales_area_zip_codes
  end
end
