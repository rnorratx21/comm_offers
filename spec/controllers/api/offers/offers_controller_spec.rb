# require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
require 'spec_helper'

describe Api::OffersController do

  ## Having trouble with initial environment setup, need to potentially upgrade to newer rspec version
  
  # describe 'GET api/offers/index' do
  #   it "should be successful" do
  #     get :index, {}
  #   end
  # end

  # before do
  #   @contract = mock_model(Contract, :invoices => [])
  #   Contract.find.stub!(:find).and_return(@contract)
  # end
  # 
  # describe "GET /admin/contracts/1/invoices/1" do
  #   before do
  #     @invoice = mock_model(Invoice)
  #     @contract.invoices.should_receive(:find).and_return(@invoice)
  #   end
  #   
  #   def do_get
  #     get :show, :contract_id => "1", :id => "1"
  #   end
  # 
  #   it "should be successful" do
  #     do_get
  #     response.should be_success
  #   end
  # end
  # 
  # describe "EDIT /admin/contracts/1/invoices/1" do
  #   before do
  #     @invoice = mock_model(Invoice)
  #     @contract.invoices.should_receive(:find).and_return(@invoice)
  #   end
  #   
  #   def do_get
  #     get :edit, :contract_id => "1", :id => "1"
  #   end
  # 
  #   it "should be successful" do
  #     do_get
  #     response.should be_success
  #   end
  #   
  #   describe "when the invoice is PAID" do
  #     it "should redirect to show"
  #     it "should set the flash message"
  #   end
  #   
  # end
  
end