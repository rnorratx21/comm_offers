class AddIsDefaultToDiscount < ActiveRecord::Migration
  def self.up
    add_column :discounts, :is_default, :boolean, :default => false
    Discount.create(:amount_off => 10, :months => 12, :setup_display => false, :description => "$10 off to start", :is_default => true)
  end

  def self.down
    remove_column :discounts, :is_default
  end
end
