require 'test_helper'

class ContractTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
    
    # puts "-- In Contract Test"
    # puts "-- Contract Plans: #{ContractPlan.all.inspect}"
    # puts "-- default contract: #{ContractPlan.default.first}"
  end

  test "build_from_default sets up a valid contract with an advertiser uses proper defaults" do
    advertiser = Advertiser.create(:name => "Foo")
    contract = advertiser.contracts.build_from_defaults
    assert_equal ContractPlan.default.first, contract.contract_plan
    assert_equal Discount.default.first, contract.contract_discount.discount
    assert contract.valid?
puts "contract: #{contract.inspect}"
  end
end
