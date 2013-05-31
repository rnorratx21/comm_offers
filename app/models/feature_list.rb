module FeatureList
  attr_accessor :feature_list
  attr_accessor :group_feature_list
  attr_accessor :addon_feature_list
  attr_accessor :addon_group_feature_list  
  attr_accessor :feature_quantity  
  attr_accessor :group_feature_quantity    
  
  private

  def update_contract_plan_features
    ContractPlanFeature.find_all_by_contract_plan_id(self.id).each {|plan| plan.delete}
    addon_features = addon_feature_list.nil? ? [] : addon_feature_list.keys.collect{|id| Feature.find_by_id(id)}
    selected_features = feature_list.nil? ? [] : feature_list.keys.collect{|id| Feature.find_by_id(id)}
    selected_features.each {|plan| 
      addon = addon_features.index(plan) ? true : false
      ContractPlanFeature.create(:feature_id=>plan.id, :contract_plan_id=>self.id, :addon=>addon, :quantity=>feature_quantity[plan.id.to_s] )
    }
  end

  def update_group_contract_plan_features
    GroupContractPlanFeature.find_all_by_group_contract_plan_id(self.id).each {|plan| plan.delete}
    addon_features = addon_group_feature_list.nil? ? [] : addon_group_feature_list.keys.collect{|id| Feature.find_by_id(id)}
    selected_features = group_feature_list.nil? ? [] : group_feature_list.keys.collect{|id| Feature.find_by_id(id)}
    selected_features.each {|plan| 
      addon = addon_features.index(plan) ? true : false
      GroupContractPlanFeature.create(:feature_id=>plan.id, :group_contract_plan_id=>self.id, :addon=>addon, :quantity=>group_feature_quantity[plan.id.to_s])
    }
  end

end
