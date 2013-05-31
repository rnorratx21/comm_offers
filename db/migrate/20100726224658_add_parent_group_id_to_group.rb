class AddParentGroupIdToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :parent_group_id, :integer
  end

  def self.down
    remove_column :groups, :parent_group_id
  end
end