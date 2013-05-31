class SetupSalesAreasForExistingContracts < ActiveRecord::Migration
  def self.up
    Contract.all.each do |c|
      next if c.sales_area
      sales_area = c.suggested_sales_area
      c.update_attributes(:sales_area => sales_area) if sales_area
    end
  end

  def self.down
  end
end
