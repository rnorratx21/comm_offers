require File.dirname(__FILE__) + '/../spec_helper'

include PricePolicies

# module PricePolicies
#   class FakePolicy < Default
#   end
# end
# 
# describe PricePolicies::FakePolicy do
#   it "describes itself as 'Fake Policy'" do
#     FakePolicy.new.name.should == "Fake Policy"
#   end
# end
# 
# describe PricePolicies::Included, "when added to an item" do
#   before :all do
#     @order_item = OrderItems::Default.new :amount => 1, :price_policy => Included.new
#   end
# 
#   it "reduces the price to 0" do
#     @order_item.price.should == 0
#   end
# end
