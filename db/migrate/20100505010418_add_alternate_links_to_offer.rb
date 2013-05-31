class AddAlternateLinksToOffer < ActiveRecord::Migration
  def self.up
    add_column :offers, :alternate_website_url, :string
    add_column :offers, :alternate_facebook_url, :string
    add_column :offers, :alternate_twitter_url, :string
  end

  def self.down
    remove_column :offers, :alternate_website_url
    remove_column :offers, :alternate_facebook_url
    remove_column :offers, :alternate_twitter_url
  end
end
