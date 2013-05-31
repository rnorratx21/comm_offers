class AddSalesFieldsToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :salesperson_id, :integer
    add_column :contracts, :sales_manager_id, :integer
    add_column :contracts, :sales_area_id, :integer
    add_column :contracts, :sales_region_id, :integer
    add_column :contracts, :payment_method, :string
  end

  def self.down
    remove_column :contracts, :payment_method
    remove_column :contracts, :sales_region_id
    remove_column :contracts, :sales_area_id
    remove_column :contracts, :sales_manager_id
    remove_column :contracts, :salesperson_id
  end
end
