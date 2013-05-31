class AddPlatinumToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :platinum, :boolean, :default => 0
  end

  def self.down
    remove_column :contracts, :platinum
  end
end
