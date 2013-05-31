require File.dirname(__FILE__) + '/../spec_helper'

# def contract
#   @order = Order.new(:advertiser_id => 123)
#   @order.add OrderItems::Default.new(:amount => 1)
#   @order.add OrderItems::Default.new(:amount => 11)
#   @contract = Contract.build_from_order(@order)
# end
# 
# describe Contract do
#   describe "build_from_order" do
#     
#     before :all do
#       contract
#     end
#     
#     it "should build the right number of invoices" do
#       @contract.should have(12).invoices
#     end
#     
#     it "should have the first invoice due today" do
#       @contract.invoices.first.due_date.to_date.should == Date.today
#     end
#     
#     it "should an advertiser_id" do
#       @contract.advertiser_id.should_not be_nil
#     end
# 
#     it "should have the same advertiser_id as the order" do
#       @contract.advertiser_id.should == 123
#     end
#     
#     describe "invoices" do
#       
#       contract.invoices.each_with_index do |invoice, i|
#         date = Date.today.advance(:months => i)
# 
#         describe "invoice #{i+1}" do
#           it "should be due #{i == 0 ? "today" : "on #{date}"}" do
#             invoice.due_date.to_date.should == date
#           end
# 
#           it "period start should be the same as the due date" do
#             invoice.period_start.to_date.should == date
#           end
# 
#           it "period end should be one month after the due date" do
#             invoice.period_end.to_date.should == date.advance(:months => 1)
#           end
#         end
#       end
#     end
#     
#     describe "first invoice" do
#       it "should have two line items"
#       it "first line item should be setup fee"
#       it "second line item should be monthly fee"
#     end
#     
#     describe "subsequent invoices" do
#       it "should have one line item"
#       it "line item should be the monthly fee"
#     end
#   end
#   
# end
