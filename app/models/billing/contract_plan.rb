class ContractPlan < ActiveRecord::Base
  has_many :group_contract_plans
  has_many :contract_plan_features
  has_many :addon_features, :class_name => "ContractPlanFeature", :conditions => ["addon = true"]
  has_many :contract_plan_discounts
  has_many :contracts
  
  validates_presence_of :due_on_day, :installments, :period, :setup_amount, :installment_amount
  
  named_scope :active, :conditions => ["is_active = TRUE"]
  named_scope :by_group, lambda { |group_ids| ( group_ids.index(Group::GLOBAL.id)) ? {} : {  :conditions => ["group_id IS NULL or group_id IN (?)", group_ids] }}
  named_scope :by_discount, lambda { |discount_id| {:joins => ["INNER JOIN contract_plan_discounts ON contract_plan_id = contract_plans.id "] , :conditions => ["contract_plan_discounts.discount_id = ?", discount_id]  } }
  named_scope :by_feature, lambda { |feature_id| {
    :joins => ["INNER JOIN contract_plan_features ON contract_plan_id = contract_plans.id "], 
    :conditions => ["contract_plan_features.feature_id = ?", feature_id]  
  } }
  named_scope :addon, :conditions => ["addon = true"]
  named_scope :unassigned, :conditions => "contract_plans.group_id IS NULL"
  named_scope :assigned,  lambda { |group_id| { :conditions => {:group_id => group_id} } }
  named_scope :default, :conditions => ["is_default = true"]
  
  after_save :update_contract_plan_discounts
  include DiscountList
  after_save :update_contract_plan_features
  include FeatureList
  
  # Explicit plan names for ranking, etc
  DIAMOND = self.find_by_system_key "diamond"
  PLATINUM = self.find_by_system_key "platinum"
  GOLD = self.find_by_system_key "gold"

  QUICK_START = self.find_by_system_key "quick_start"
  ENHANCED = self.find_by_system_key "enhanced"
  BRAND_BUILDER = self.find_by_system_key "brand_builder"

  def build_contract(options={})
    contract = self.contracts.build(options)
    
    for event in Recurrence.new(:every => period, :on => due_on_day, :until => Date.today.advance(period.pluralize.intern => installments)).events
      invoice = contract.invoices.build(
        :issue_date => Date.today,
        :due_date => event,
        :period_start => event,
        :period_end => (event.advance(period.pluralize.intern => 1) - 1.day),
        :status => "open",
        :contract => contract
      )
      
      invoice.line_items << line_item = LineItem.new(
        :net_amount => installment_amount,
        :description => name,
        :quantity => 1,
        :ledger_item => invoice
      )
      
      if discount_amount > 0
        invoice.line_items << line_item = LineItem.new(
          :net_amount => discount_amount * -1,
          :description => "Discount",
          :quantity => 1,
          :ledger_item => invoice
        )
      end # if discount_amount > 0
    end
    
    if setup_amount
      contract.invoices.first.line_items << LineItem.new(
        :net_amount => setup_amount,
        :description => "Setup Fee",
        :quantity => 1,
        :ledger_item => contract.invoices.first
      )
    end # if setup_amount
    return contract
    
  end

  def display_name
    "#{name}"
  end

  def installment_with_discount(discount)
    self.installment_amount - discount.actual_amount(self.installment_amount)
  end
end
