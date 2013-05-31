class CreateWifiLogins < ActiveRecord::Migration
  def self.up
    create_table :wifi_logins do |t|
      t.integer :user_id
      t.integer :contract_id
      t.string :user_agent
      t.string :first_name
      t.string :last_name
      t.string :mobile_phone
      t.string :email
      t.string :wifi_nasid
      t.string :wifi_res
      t.string :wifi_uamip
      t.string :wifi_uamport
      t.string :wifi_challenge
      t.string :wifi_called
      t.string :wifi_mac
      t.string :wifi_ip
      t.string :wifi_sessionid
      t.string :wifi_userurl
      t.string :wifi_username
      t.string :wifi_password      
      t.timestamps
    end
  end

  def self.down
    drop_table :wifi_logins
  end
end
