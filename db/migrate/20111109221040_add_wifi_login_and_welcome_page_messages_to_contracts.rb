class AddWifiLoginAndWelcomePageMessagesToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :wifi_login_page_message, :string
    add_column :contracts, :wifi_welcome_page_message, :string
  end

  def self.down
    remove_column :contracts, :wifi_welcome_page_message
    remove_column :contracts, :wifi_login_page_message
  end
end
