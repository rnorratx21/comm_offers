require File.dirname(__FILE__) + '/../spec_helper'

include PricePolicies
include OrderItems

describe OrderBuilder, "when ordering a gold plan with a zip code block" do

  # before :all do
  #   @builder = OrderBuilder.new
  #   @gold_plan = GoldPlan.new
  #   @zip_code_block = OrderItems::ZipCodeBlock.new
  #   @order = @builder.make [@gold_plan, @zip_code_block]
  # end
  # 
  # it "adds the gold plan to the order" do
  #   @order.items.should include(@gold_plan)
  # end
  # 
  # it "adds the zip code block to the order" do
  #   @order.items.should include(@zip_code_block)
  # end
  # 
  # it "doesn't add a setup fee" do
  #   @order.item(SetupFee).should be_nil
  # end
  # 
  # it "doesn't charge for the zip code block" do
  #   @zip_code_block.price_policy.instance_of?(Included).should be_true
  # end
end

describe OrderBuilder, "when ordering a gold plan with more than one zip code blocks" do
  # before :all do
  #   @builder = OrderBuilder.new
  #   @plan = GoldPlan.new
  #   @zip_code_block_1 = OrderItems::ZipCodeBlock.new
  #   @zip_code_block_2 = OrderItems::ZipCodeBlock.new
  #   @order = @builder.make [@plan, @zip_code_block_1, @zip_code_block_2]
  # end
  # 
  # it "charges for the first zip code block" do
  #   @zip_code_block_1.price_policy.instance_of?(Included).should be_true
  # end
  # 
  # it "doesn't charge for the second zip code block" do
  #   @zip_code_block_2.price_policy.instance_of?(Included).should be_false
  # end
end

describe OrderBuilder, "when ordering a platinum plan with zip codes" do
  # before :all do
  #   @builder = OrderBuilder.new
  #   @plan = PlatinumPlan.new
  #   @zip_code_block = OrderItems::ZipCodeBlock.new
  #   @order = @builder.make [@plan, @zip_code_block]
  # end
  # 
  # it "adds a setup fee" do
  #   @order.item(SetupFee).should_not be_nil
  # end
  # 
  # it "charges for zip code blocks" do
  #   @zip_code_block.price_policy.instance_of?(PricePolicies::Default).should be_true
  # end
end

describe OrderBuilder, "when ordering a gold plan without zip codes" do
  # before :all do
  #   @builder = OrderBuilder.new
  #   plan = GoldPlan.new
  # 
  #   @builder.track_methods(:first_zip_code_block_is_included)
  #   
  #   @builder.make [plan]
  # end
  # 
  # it "does not make any zip code blocks 'included'" do
  #   @builder.should_not have_received(:first_zip_code_block_is_included)
  # end
end
