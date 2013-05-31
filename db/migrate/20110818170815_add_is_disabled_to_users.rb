class AddIsDisabledToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_disabled, :boolean, :default => false
  end

  def self.down
    remove_column :users, :is_disabled
  end
end
