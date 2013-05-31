class AddUpgradeRequestDateToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :upgrade_request_date, :date
  end

  def self.down
    remove_column :contracts, :upgrade_request_date
  end
end
