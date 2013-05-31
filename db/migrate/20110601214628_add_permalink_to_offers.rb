class AddPermalinkToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :permalink, :string
  end

  def self.down
    remove_column :offers, :permalink
  end
end
