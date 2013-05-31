class AddDisclaimersToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :disclaimers, :string
  end

  def self.down
    remove_column :offers, :disclaimers
  end
end
