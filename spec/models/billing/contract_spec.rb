require File.dirname(__FILE__) + '/../../spec_helper'

describe Contract do
  
  # describe "from Order" do
  #   before do
  #     @order = Order.new
  #     @order.add OrderItems::Default.new(:amount => 125, :recurrence => :once, :name => "Setup Fee")
  #     @order.add OrderItems::Default.new(:amount => 149, :recurrence => :monthly, :name => "Platinum Monthly")
  #     @contract = Contract.build_from_order(@order)
  #   end
  # 
  #   describe "total" do
  #     it "should sum the totals of the invoices" do
  #       @contract.total.to_s.should == "1913.0"
  #     end
  # 
  #     it "should format the total" do
  #       @contract.total_formatted.should == "$1,913.00"
  #     end
  #   end
  # end
  # 
  # describe "from ContractPlan" do
  #   before do
  #     @advertiser = Advertiser.create(:name => "Garden of Eat'n")
  #     @offer = Offer.create(:advertiser => @advertiser, :headline => "Headline", :title => "Title", :description => "Description", :hours => "Today", :effective => "Immediately", :payment_methods => "Left Arm, Left Leg")
  #     @contract_plan = ContractPlan.create(:name => "value for name", :start_after => 1, :setup_amount => 9.99, :tax_rate => 1, :installment_amount => 9.99, :period => "month", :installments => 12, :due_on_day => 28 )
  #     @contract = @contract_plan.build_contract(:offer_ids => [@offer.id])
  #   end
  #   
  #   it "should assign the advertiser from the offer" do
  #     @contract.save
  #     @contract.advertiser.should == @offer.advertiser
  #   end
  #   
  # end
  # 
  
end