class OfferRedeemableTimeframe < ActiveRecord::Base
  belongs_to :offer
  
  attr_accessor :start_hour_selection, :start_minute_selection, :end_hour_selection, :end_minute_selection

  validates_presence_of :offer, :day, :start_minute, :end_minute
  validates_inclusion_of :day, :in => %w(sunday monday tuesday wednesday thursday friday saturday sunday)
  validates_uniqueness_of :day, :scope => :offer_id
  validate :end_after_start
  
  def end_after_start
    if self.end_minute and self.start_minute
      unless self.end_minute > self.start_minute
        errors.add_to_base("The end time must come after the start time")
      end
    end
  end
end
