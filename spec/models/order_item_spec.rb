require File.dirname(__FILE__) + '/../spec_helper'

include OrderItems

# class SomeItem < Default
# end
# 
# class SomePricePolicy < PricePolicies::Default
# end
# 
# describe "Order item name" do
#   it "is the title casing of the class name after demodulizing it" do
#     SomeItem.new(:amount => 1).name.should == "Some Item"
#   end
# end
# 
# describe "Order item name when a price policy has been applied" do
#   before :all do
#     @item = SomeItem.new(:amount => 1)
#     @item.price_policy = SomePricePolicy.new
#   end
#   
#   it "includes the name of the price policy" do
#     @item.name.should == "Some Item (Some Price Policy)"
#   end
# end
# 
# describe Default, "when not using a price policy" do
#   before :all do
#     @item = Default.new(:amount => 1)
#   end
#   
#   it "uses the default policy" do
#     @item.price_policy.instance_of?(PricePolicies::Default).should be_true
#   end
# end
# 
# describe Default, "when calculating the amount" do
#   before :all do
#     @policy = PricePolicies.default
#     @policy.track_methods(:price)
#         
#     @item = Default.new(:amount => 1, :price_policy => @policy)
#     @item.price
#   end
#   
#   it "applies the price policy for the item" do
#     @policy.should have_received(:price)
#   end
# end
# 
# describe OrderItems::ZipCodeBlock, "when building for a list of ten zip codes" do
#   it "creates one zip code block" do
#     zip_code_blocks = ZipCodeBlock.build((1..10).to_a)
#     zip_code_blocks.length.should == 1
#   end
# end
# 
# describe OrderItems::ZipCodeBlock, "when building for a list of a multiple of ten zip codes" do
#   it "creates a zip code block for every ten zip codes" do
#     zip_code_blocks = ZipCodeBlock.build((1..20).to_a)
#     zip_code_blocks.length.should == 2
#   end
# end
# 
# describe OrderItems::ZipCodeBlock, "when building for a list ten zip codes with a remainer of zip codes over a multiple of ten" do
#   it "creates a zip code block for the remainder of zip codes" do
#     zip_code_blocks = ZipCodeBlock.build((1..25).to_a)
#     zip_code_blocks.length.should == 3
#   end
# end
# 
# describe OrderItems::ZipCodeBlock, "when building for a list of less than ten zip codes" do
#   it "creates one zip code block" do
#     zip_code_blocks = ZipCodeBlock.build((1..5).to_a)
#     zip_code_blocks.length.should == 1
#   end
# end
