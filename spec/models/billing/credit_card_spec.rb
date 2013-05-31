require File.dirname(__FILE__) + '/../../spec_helper'
include ActiveMerchant::Billing

# def credit_card_attributes(attrs={})
#   {
#     :number => '1',
#     :first_name => 'Test',
#     :last_name => 'Example',
#     :expires_on => (Date.today+1.year),
#     :verification_value => '123',
#     :type => 'visa',
#     :zip_code => '99362'
#   }.update(attrs)
# end
# 
# def credit_card(options={})
#   ActiveMerchant::Billing::CreditCard.new( credit_card_attributes(options) )
# end
# 
# def address(options={})
#   {
#     :name => 'Test Example',
#     :address1 => '1234 Wishy Washy Ave',
#     :city => 'Wallawalla',
#     :state => 'WA',
#     :country => 'US',
#     :zip => '99362'
#   }.update(options)
# end
# 
# describe CreditCard do
#   before do
#     # @contract = Factory.create(:contract)
#   end
#   
#   describe "store!" do
#     describe "success" do
#       before do
#         @credit_card = CreditCard.new(credit_card_attributes)
#         @credit_card.track_methods(:store!)
#         @credit_card.save!
#       end
#       it "should store before save" do
#         @credit_card.should have_received(:store!)
#       end
#       
#       it "should store the masked card number" do
#         @credit_card.display_number.should == "XXXX-XXXX-XXXX-1"
#       end
# 
#       it "should get a billing_token" do
#         @credit_card.billing_token.should == "53433"
#       end
#     end
#     
#     describe "failure" do
#       before do
#         @credit_card = CreditCard.new(credit_card_attributes(:number => '2'))
#         @credit_card.track_methods(:store!)
#       end
#       
#       it do
#         @credit_card.should_not be_valid
#       end
#       
#       it "should not save" do
#         @credit_card.save.should be_false
#       end
#       
#       it "should add errors to base" do
#         @credit_card.save
#         @credit_card.errors.full_messages.should == [BogusGateway::FAILURE_MESSAGE]
#       end
#     end
#     
#   end
#   
#   describe "save" do
#     before do
#       @credit_card = CreditCard.new(credit_card_attributes)
#       @credit_card.save!
#     end
#   end
#   
# end