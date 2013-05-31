class AddCustomMarkupToAffiliateOffers < ActiveRecord::Migration
  def self.up
    add_column :affiliate_offers, :custom_markup, :text
  end

  def self.down
    remove_column :affiliate_offers, :custom_markup
  end
end
