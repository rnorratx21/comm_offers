class AddStateToAffiliateOffers < ActiveRecord::Migration
  def self.up
    add_column :affiliate_offers, :state, :string
  end

  def self.down
    remove_column :affiliate_offers, :state
  end
end
