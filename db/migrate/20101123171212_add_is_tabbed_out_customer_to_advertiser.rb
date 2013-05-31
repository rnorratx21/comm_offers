class AddIsTabbedOutCustomerToAdvertiser < ActiveRecord::Migration
  def self.up
    add_column :advertisers, :is_tabbed_out_customer, :boolean
  end

  def self.down
    remove_column :advertisers, :is_tabbed_out_customer
  end
end
