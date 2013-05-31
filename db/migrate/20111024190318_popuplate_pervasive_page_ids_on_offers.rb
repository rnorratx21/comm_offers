require 'fastercsv'
class PopuplatePervasivePageIdsOnOffers < ActiveRecord::Migration
  def self.up
    FasterCSV.foreach("#{RAILS_ROOT}/data/pervasive_offers_pageids_20111020.csv", {:headers => true}) do |row|
      coupon_id = row['CouponID']
      # puts "Reviewing #{coupon_id}"
      page_id = row['PageID']  
      offer = Offer.find_by_mobile_id(coupon_id)
      if offer and page_id and !offer.pervasive_page_id
        offer.pervasive_update_flag = false
        offer.update_attributes(:pervasive_page_id => page_id)
        puts "Assigning page #{page_id} to coupon #{coupon_id} on offer #{offer.id}"
      end
    end
    Offer.with_pervasive(:conditions => ["pervasive_page_id IS NULL"]).each do |offer|
      advertiser = offer.advertiser
      if (advertiser.offers.size == 1) and advertiser.mobile_id
        # puts "trying for #{offer.id}"
        offer.pervasive_update_flag = false
        puts "Updating offer #{offer.id} with page #{advertiser.mobile_id} from advertiser #{advertiser.id}"
        offer.update_attributes(:pervasive_page_id => advertiser.mobile_id)
      end
    end
  end

  def self.down
  end
end
