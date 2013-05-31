class AddAlternateLogoToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :alternate_logo, :string
  end

  def self.down
    drop_column :offers, :alternate_logo
  end
end
