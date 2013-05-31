class AddConsumerToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :consumer, :boolean, :default => false
  end

  def self.down
    remove_column :users, :consumer
  end
end
