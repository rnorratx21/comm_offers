class GeneratePermalinksForExistingOffers < ActiveRecord::Migration
  def self.up
    Offer.reset_column_information
    Offer.all.each do |offer|
      offer.check_permalink
      offer.pervasive_update_flag = false
      offer.save
    end
  end

  def self.down
  end
end
