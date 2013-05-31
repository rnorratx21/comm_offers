class AddAlternateBizNameToOffer < ActiveRecord::Migration
  def self.up
    add_column :offers, :alternate_business_name, :string
  end

  def self.down
    drop_column :offers, :alternate_business_name
  end
end
