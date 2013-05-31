require 'test_helper'

class Api::OffersControllerTest < ActionController::TestCase
  setup do
    @offer = Factory.create(:offer)
    puts @offer.inspect
  end
  # Replace this with your real tests.
  test "should_get index" do
    get :index
    assert_response :success
  end
end
