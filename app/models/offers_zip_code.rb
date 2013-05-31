class OffersZipCode < ActiveRecord::Base
  belongs_to :zip_code
  belongs_to :offer
  named_scope :by_group, lambda { |group_ids| ( group_ids.index(Group::GLOBAL.id)) ? {} : {   :joins => ["INNER JOIN offers ON offers.id = offers_zip_codes.offer_id ",
                 "INNER JOIN advertisers ON advertisers.id = offers.advertiser_id"] , :conditions => ["advertisers.group_id in (?)", group_ids]  } }

  named_scope :unique_zip_codes, :group => "zip_code_id"

  named_scope :by_order, lambda { |order_by| { 
    :select => "zip_code_id, count(offer_id) as offers_count", 
    :joins => "left join zip_codes ON offers_zip_codes.zip_code_id = zip_codes.id", 
    :order => order_by 
  } }

  
  class << self
    def zip_codes order_by
      unique_zip_codes.by_order(order_by).collect(&:zip_code)
    end
  end
  
end