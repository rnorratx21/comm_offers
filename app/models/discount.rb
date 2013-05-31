class Discount < ActiveRecord::Base
  has_many :group_contract_plan_discounts, :dependent => :destroy
  has_many :contract_plan_discounts, :dependent => :destroy
  
  after_save :update_contract_plan_discounts
  after_save :update_group_contract_plan_discounts
  include ContractPlanList
  
  validates_uniqueness_of :promo_code
  validates_presence_of :promo_code

  named_scope :by_contract_plan, lambda { |contract_plan_id| {:joins => ["INNER JOIN contract_plan_discounts ON discount_id = discounts.id "] , :conditions => ["contract_plan_discounts.contract_plan_id = ?", contract_plan_id]  } }
  named_scope :by_group_contract_plan, lambda { |group_contract_plan_id| {:joins => ["INNER JOIN group_contract_plan_discounts ON discount_id = discounts.id "] , :conditions => ["group_contract_plan_discounts.group_contract_plan_id = ?", group_contract_plan_id]  } }
  named_scope :default, :conditions => ["is_default = true"]

  def actual_amount(subtotal){}
    self.amount_off || self.percent_off/100.to_f * subtotal
  end
end
