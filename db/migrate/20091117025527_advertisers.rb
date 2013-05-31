class Advertisers < ActiveRecord::Migration
  def self.up
    create_table :advertisers do |t|
      t.string :name
      t.integer :address_id 
      t.string :logo
      t.string :twitter_url
      t.string :facebook_url
      t.string :website_url
      t.string :feed_url
      t.timestamps
    end
  end
  
  def self.down
    drop_table :advertisers
  end
end
