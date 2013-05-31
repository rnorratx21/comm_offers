class AddWifiNasidToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :wifi_nasid, :string
  end

  def self.down
    remove_column :contracts, :wifi_nasid
  end
end
