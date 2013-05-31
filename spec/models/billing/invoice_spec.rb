require File.dirname(__FILE__) + '/../../spec_helper'
include ActiveMerchant::Billing

describe Invoice do
  
  before do
    @credit_card = Factory.create(:credit_card)
    @plan = Factory.create(:contract_plan)
    @contract = @plan.build_contract(:credit_card => @credit_card, :advertiser => Advertiser.create!(:name => "Foo Ads"))
    @invoice = @contract.invoices.first
    # puts "@cc #{@credit_card.valid?}"
    # puts "@plan #{@plan.valid?}"
    # puts "@contract #{@contract.valid?}"
    # puts "@invoice: #{@invoice.valid?}"
  end
  
  # it "should be open" do
  #   @invoice.status.should == "open"
  # end
  # 
  # it "should belong to contract" do
  #   @invoice.contract.should == @contract
  # end
  # 
  # it "should have an amount" do
  #   @invoice.calculate_total_amount.to_s.should == "200.0"
  # end
  
  # describe "pay!" do
  #   before do
  #     @contract.save!
  #   end
  #   describe "success" do
  #     before do
  #       @credit_card.stub_method(:purchase! => Response.new(true, 'Success'))
  #       @contract.save
  #       # @invoice.stub_method(:credit_card => @credit_card)
  #     end
  #     it "should create a payment" do
  #       lambda{
  #         @invoice.pay!
  #       }.should change(Payment, :count).by(1)
  #     end
  #     it "should be success" do
  #       @invoice.pay!.should be_true
  #     end
  #     it "should have the right number of items" do
  #       @invoice.pay!
  #       @invoice.payments.first.should have(2).line_items
  #     end
  #     it "payment should be the right amount" do
  #       @invoice.pay!
  #       @invoice.payments.first.calculate_total_amount.to_s.should == "200.0"
  #     end
  #     it "paid? should be false until it's paid" do
  #       @invoice.paid?.should == false
  #     end
  #     it "should mark the invoice as paid" do
  #       @invoice.pay!
  #       @invoice.paid?.should == true
  #     end
  #     it "should mark the invoice as closed" do
  #       @invoice.pay!
  #       @invoice.reload.status.should == "closed"
  #     end
  #   end
  #   
    # describe "failure" do
    #   
    #   before do
    #     @credit_card = Factory.build(:credit_card, :number => '2')
    #     @credit_card.stub_method(:purchase! => Response.new(false, BogusGateway::FAILURE_MESSAGE))
    #   
    #     @payment = @invoice.build_payment(:contract => @contract)
    #     @payment.stub_method(:credit_card => @credit_card)
    #     
    #     @invoice.stub_method(:build_payment => @payment)
    #     @invoice.pay!
    #     @payment = @invoice.payments.first
    #     
    #   end
    #   
    #   it "should create a payment item" do
    #     @invoice.should have(1).payments
    #   end
    #   
    #   it "should remain open" do
    #     @invoice.reload.status.should == "open"
    #   end
    #   
    #   it "payment should have failed status" do
    #     @payment.status.should == "failed"
    #   end
    #   
    #   it "payment should have line item" do
    #     @payment.should have(@invoice.line_items.count).line_items
    #   end
    #   
    #   it "payment should have error messages in the line item" do
    #     @payment.description.should == BogusGateway::FAILURE_MESSAGE
    #   end
    # end
  # end
  
  describe "from order" do
    before do
      @order = Order.new(@contract)
      # @order.add({:name => "Setup Fee", :recurrence => :once, :price => 125 })
      # @order.add OrderItems::Default.new(:amount => 125, :recurrence => :once, :name => "Setup Fee")
      @offer = Factory.create(:offer)
      Contract.build_from_order(@contract, @order, :offers => [@offer])
      @contract.save!
      @invoice = @contract.invoices.first
    end
  
    it "should have order" do
      # Debugger.start; debugger
  
    end
  
    it "should have an amount" do
      @invoice.calculate_total_amount.to_s.should == "150.0"
    end
  
    it "should belong to the contract" do
      @invoice.contract.should == @contract
    end
    
  end
  # 
  # 
  # describe "unpaid" do
  #   before do
  #     pending "not scoping unpaid"
  #   end
  #   it "should include this invoice" do
  #     Invoice.unpaid.should include(@invoice)
  #   end
  #   
  #   # http://flouri.sh/2008/11/22/duplicate-joins-merge-in-rails-2-2
  #   it "should not include after pay!" do
  #     @invoice.pay!
  #     Invoice.unpaid.should_not include(@invoice)
  #   end
  #   
  # end
  # 
  # describe "Exceptions" do
  #   describe "with no credit card" do
  #     before do
  #       @invoice.stub_method(:credit_card => nil)
  #     end
  # 
  #     it "credit card should be nil" do
  #       @invoice.credit_card.should be_nil
  #     end
  # 
  #     it "should raise InvoiceException::NoCreditCard" do
  #       lambda{
  #         @invoice.pay!
  #       }.should raise_error(InvoiceException::NoCreditCard)
  #     end
  #   end
  #   
  #   describe "already paid" do
  #     before do
  #       @invoice.stub_method(:paid? => true)
  #     end
  #     
  #     it "should be paid" do
  #       @invoice.paid?.should be_true
  #     end
  #     it "should raise InvoiceException::InvoicePaid" do
  #       lambda{
  #         @invoice.pay!
  #       }.should raise_error(InvoiceException::InvoicePaid)
  #     end
  # 
  #   end
  # end

end