class AddSkipFlagsToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :skip_website_url, :boolean
    add_column :offers, :skip_facebook_url, :boolean
    add_column :offers, :skip_twitter_url, :boolean
    add_column :offers, :skip_logo, :boolean
  end

  def self.down
    remove_column :offers, :skip_website_url
    remove_column :offers, :skip_facebook_ur
    remove_column :offers, :skip_twitter_url
    remove_column :offers, :skip_logo
  end
end
