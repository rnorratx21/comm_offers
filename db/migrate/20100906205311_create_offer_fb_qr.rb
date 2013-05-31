class CreateOfferFbQr < ActiveRecord::Migration
  def self.up
    add_column :offers, :mobile_uri, :string
  end

  def self.down
    remove_column :offers, :mobile_uri
  end
end
