require File.dirname(__FILE__) + '/../spec_helper'

# describe Order, "when calculating the total" do
#   before :all do
#     @order = Order.new
#     @order.add OrderItems::Default.new(:amount => 1)
#     @order.add OrderItems::Default.new(:amount => 11)
#   end
#   
#   it "adds the items" do
#     @order.total.should == 12
#   end
# end
# 
# describe Order, "when adding items" do
#   before :all do
#     order = Order.new
#     @item = OrderItems::Default.new(:amount => 1)
#     order.add @item
# 
#     @item.track_methods(:price)
#     
#     order.total
#   end
#   
#   it "adds the prices" do
#     @item.should have_received(:price)
#   end
# end
# 
# describe Order, "when finding items by type" do
#   before :all do
#     order = Order.new
#     order.add OrderItems::GoldPlan.new()
#     order.add OrderItems::PlatinumPlan.new()
#     order.add OrderItems::GoldPlan.new()
#     
#     @found = order.items_by_class OrderItems::GoldPlan
#   end
#   
#   it "collects all items that match" do
#     @found.length.should == 2
#   end
#   
#   specify "items are instances of the given class" do
#     @found.each {|item| item.should be_instance_of(OrderItems::GoldPlan) }
#   end 
# end
# 
# describe Order, "when finding items by recurrence" do
#   before :all do
#     order = Order.new
#     order.add OrderItems::GoldPlan.new(:recurrence => :some_recurrence)
#     order.add OrderItems::PlatinumPlan.new(:recurrence => :some_recurrence)
#     order.add OrderItems::GoldPlan.new()
#     
#     @found = order.items_by_recurrence :some_recurrence
#   end
#   
#   it "collects all items that match" do
#     @found.length.should == 2
#   end
#   
#   specify "items have the given recurrence" do
#     @found.each {|item| item.recurrence.should == :some_recurrence }
#   end	
# end