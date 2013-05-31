class AddGroupToAdvertisers < ActiveRecord::Migration
  def self.up
    add_column :advertisers, :group_id, :integer
  end

  def self.down
    remove_column :advertisers, :group_id
  end
end
