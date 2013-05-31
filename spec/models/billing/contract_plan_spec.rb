require 'spec_helper'

# describe ContractPlan do
#   before(:each) do
#     @valid_attributes = {
#       :name => "value for name",
#       :start_after => 1,
#       :setup_amount => 9.99,
#       :tax_rate => 1,
#       :installment_amount => 9.99,
#       :period => "month",
#       :installments => 12,
#       :due_on_day => 28
#     }
#     @plan = ContractPlan.new(@valid_attributes)
#   end
#   
#   it "should be valid" do
#     @plan.should be_valid
#   end
# 
#   it "should create a new instance given valid attributes" do
#     ContractPlan.create!(@valid_attributes)
#   end
#   
#   describe "build_contract" do
#     
#     before do
#       @contract = @plan.build_contract
#     end
#     
#     it "should create a contract" do
#       @contract.should be_an_instance_of(Contract)
#     end
#     
#     it "should build the right number of invoices" do
#       @contract.should have(12).invoices
#     end
#   end
#   
#   describe "with discount" do
#     before do
#       @plan = ContractPlan.new(@valid_attributes.with(:discount_amount => "100", :setup_amount => "0", :installment_amount => "149"))
#       @contract = @plan.build_contract
#     end
#     
#     it "should apply discount" do
#       format_currency(@contract.invoices.first.calculate_total_amount).should == "$49.00"
#     end
#   end
#   
# end
# 
# def format_currency(val, options={})
#   Invoicing::CurrencyValue::Formatter.format_value("USD", val, options)
# end