class OffersZipCodes < ActiveRecord::Migration
  def self.up
	  create_table :offers_zip_codes, :id => false do |t|
      t.integer :offer_id
      t.string :zip_code_id
      t.timestamps
		end
  end

  def self.down
		drop_table :offers_zip_codes
  end
end
