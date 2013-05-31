require 'test_helper'

class OfferRedeemableTimeframeTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup 
    CategoryType.create(:name => "Foo Type").categories.create(:name => "Foo")
    @advertiser = Advertiser.create(:name => "Foo")
    @offer = @advertiser.offers.create(
      :headline => "Offer Headline",
      :title => "Offer Title",
      :description => "Offer description",
      :hours => "Offer hours",
      :effective => "Offer effective",
      :payment_methods => "Offer payment misc",
      :category => Category.last,
      :expires_on => 10.days.from_now 
    )
    raise "Advertiser setup not valid: #{@advertiser.errors.inspect}}" unless @advertiser.valid?
  end

  test "that offer_redeemable_timeframe can be created" do
    ort = @offer.redeemable_timeframes.build
    ort.day = "monday"
    ort.start_minute = 7 * 60 #7AM
    ort.end_minute = 17 * 60 #5PM
    assert ort.valid?
  end

  test "that two redeemable_timeframes cannot be created on same day" do
    ort_friday = @offer.redeemable_timeframes.build
    ort_friday.day = "friday"
    ort_friday.start_minute = 12 * 60 #12pm
    ort_friday.end_minute = 13 * 60 #1pm
    assert ort_friday.save

    ort_2 = @offer.redeemable_timeframes.build
    ort_2.day = 'friday'
    ort_2.start_minute = 14 * 60 #12pm
    ort_2.end_minute = 15 * 60 #1pm
    assert !ort_2.valid?
    assert ort_2.errors.on(:day)
  end

  test "that day can only be valid days of the week" do
    ort = OfferRedeemableTimeframe.new(:day => "foo")
    ort.save
    assert ort.errors.on(:day)
    assert ort.errors.on(:day).include? "is not included in the list"
  end
end
