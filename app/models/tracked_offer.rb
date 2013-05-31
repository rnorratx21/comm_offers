class TrackedOffer < ActiveRecord::Base
  belongs_to :tracker, :class_name => "User", :foreign_key => "user_id"
  belongs_to :offer

  validates_presence_of :tracker, :offer

  # named_scope :for_offer, lambda |offer_id| {
  #   :conditions => {:offer_id => offer_id}
  # }
end
