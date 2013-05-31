class CreateWifiUdps < ActiveRecord::Migration
  def self.up
    create_table :wifi_udps do |t|
      t.integer :contract_id
      t.string :wifi_nasid
      t.string :wifi_mac

      t.timestamps
    end
  end

  def self.down
    drop_table :wifi_udps
  end
end
