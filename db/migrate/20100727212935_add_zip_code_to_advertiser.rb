class AddZipCodeToAdvertiser < ActiveRecord::Migration
  def self.up
    add_column :advertisers, :zip_code_id, :integer
  end

  def self.down
    remove_column :advertisers, :zip_code_id
  end
end