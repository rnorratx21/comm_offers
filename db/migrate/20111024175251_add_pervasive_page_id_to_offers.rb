class AddPervasivePageIdToOffers < ActiveRecord::Migration
  def self.up
    add_column :offers, :pervasive_page_id, :integer
  end

  def self.down
    remove_column :offers, :pervasive_page_id
  end
end
