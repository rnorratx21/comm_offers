class GroupContractPlan < ActiveRecord::Base
  belongs_to :group
  belongs_to :contract_plan
  has_many :group_contract_plan_discounts
  has_many :group_contract_plan_features
  has_many :contracts

  named_scope :by_discount, lambda { |discount_id| {:joins => ["INNER JOIN group_contract_plan_discounts ON group_contract_plan_id = group_contract_plans.id "] , :conditions => ["group_contract_plan_discounts.discount_id = ?", discount_id]  } }
  named_scope :by_feature, lambda { |feature_id| {
    :joins => ["INNER JOIN group_contract_plan_features ON group_contract_plan_id = group_contract_plans.id "] , 
    :conditions => ["group_contract_plan_features.feature_id = ?", feature_id]  } 
  }
  named_scope :addon, # Adam says we can assume we'll always have the join we need to expose the addon column
    :joins => ["INNER JOIN group_contract_plan_features ON group_contract_plan_id = group_contract_plans.id "] , 
    :conditions => ["group_contract_plan_features.addon = true"] 
 
  after_save :update_group_contract_plan_discounts
  include DiscountList
  after_save :update_group_contract_plan_features
  include FeatureList

  def name
    plan = self.contract_plan_id? ? self.contract_plan.display_name : "Plan"
    group = self.group_id? ? self.group.name : "Plan"
    group + " - " + plan
  end

end
