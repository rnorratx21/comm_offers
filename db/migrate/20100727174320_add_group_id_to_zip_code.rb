class AddGroupIdToZipCode < ActiveRecord::Migration
  def self.up
    add_column :zip_codes, :group_id, :integer
  end

  def self.down
    remove_column :zip_codes, :group_id
  end
end