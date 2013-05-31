class Feature < ActiveRecord::Base
  has_many :group_contract_plan_features
  has_many :contract_plan_features, :dependent => :destroy
  
  after_save :update_contract_plan_features
  after_save :update_group_contract_plan_features
  include ContractPlanList
  
  named_scope :by_contract_plan, lambda { |contract_plan_id| {
    :joins => ["INNER JOIN contract_plan_features ON contract_plan_features.feature_id = features.id "], 
    :conditions => ["contract_plan_features.contract_plan_id = ?", contract_plan_id]  
  } }
  named_scope :by_group_contract_plan, lambda { |group_contract_plan_id| {
    :joins => ["INNER JOIN group_contract_plan_features ON group_contract_plan_features.feature_id = features.id "], 
    :conditions => ["group_contract_plan_features.group_contract_plan_id = ?", group_contract_plan_id]  
  } }
  named_scope :plan_addon, :conditions => ["addon = true"] # For use when a CPF or GCPF is already joined
  named_scope :all_addon, :joins => :contract_plan_features, :conditions => ["addon = true"] # if no join already used
  named_scope :group_addon, :conditions => ["group_contract_plan_features.addon = true"]

  ADDL_ZIPS_KEY = "addl_zip_block"
end
