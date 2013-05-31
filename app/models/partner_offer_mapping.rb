class PartnerOfferMapping < ActiveRecord::Base
  belongs_to :partner
  belongs_to :offer
    
  validates_presence_of :partner_id, :offer_id, :partner_id_value
  validates_uniqueness_of :offer_id, :scope => [:partner_id], :message => 'has already been mapped'
  validates_uniqueness_of :partner_id_value, :scope => [:partner_id], :message => 'has already been mapped for an offer'
end
