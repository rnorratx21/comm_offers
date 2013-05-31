require 'test_helper'

class ContractBuilderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  def setup
    @contract_plan = ContractPlan.create(:system_key => "magenta", :name => "Magenta", :setup_amount => 100, :installment_amount => 200, :due_on_day => 27, :installments => 12, :period => 'month')
    @advertiser = Advertiser.create(:name => "Foo")
    @contract = @advertiser.contracts.create(:contract_plan => @contract_plan)
    @offer = @advertiser.offers.create(:contract => @contract)
    @order = Order.new(@contract)
  end
  
  test "contract builder generates 12 invoices" do
    contract = Contract.build_from_order(@contract, @order)
    # print_invoices(contract)
    assert contract.invoices.size == 12
  end
  
  test "contract discount amount debits from monthly invoices" do
    discount = load_discount
    @contract_plan.contract_plan_discounts.create(:discount => discount)
    # @order.discount_id = discount
    @contract.create_contract_discount(:discount => discount)
    @order = Order.new(@contract)
    contract = Contract.build_from_order(@contract, @order)
    contract.save
    # puts "NO DISCOUNT"
    # print_invoices(contract)

  end

  test "contract discount amount debits from monthly installments, not addons" do
    discount = load_discount
    @contract_plan.contract_plan_discounts.create(:discount => discount)
    Feature.all.each{|f| @contract_plan.contract_plan_features.create(:feature => f, :addon => true)}
    # @order.discount_id = discount
    @contract.create_contract_discount(:discount => discount)
    @contract_plan.contract_plan_features.each{|cf| @contract.contract_features.create(:feature => cf.feature)}
    @order = Order.new(@contract)
    contract = Contract.build_from_order(@contract, @order)
    contract.save
    # print_invoices(contract)

  end
  
  private
    def load_discount
      @discount ||= begin
        Discount.create(:promo_code => "TESTCODEFORME", :percent_off => 100, :months => 4, :setup_display => true)
      end
    end

    def print_invoices(contract)
      contract.invoices.each_with_index do |invoice,idx|
        invoice.line_items.each do |item|
          puts " - LI: #{item.description}, #{item.net_amount}"
        end
      end
    end
end
