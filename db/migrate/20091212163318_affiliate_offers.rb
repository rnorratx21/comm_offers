class AffiliateOffers < ActiveRecord::Migration
  def self.up
    create_table :affiliate_offers do |t|
      t.string :name
      t.string :kind
      t.string :logo
      t.string :headline
      t.string :title
      t.string :website_url
      t.string :view_content
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :affiliate_offers
  end
end
