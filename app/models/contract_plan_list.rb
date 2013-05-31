module ContractPlanList
  attr_accessor :plan_list
  attr_accessor :group_plan_list
  attr_accessor :addon_plan_list
  attr_accessor :addon_group_list  
  attr_accessor :feature_quantity  
  attr_accessor :group_feature_quantity   
    
  private

  def update_contract_plan_discounts
    ContractPlanDiscount.find_all_by_discount_id(self.id).each {|plan| plan.delete}
    selected_contract_plans = plan_list.nil? ? [] : plan_list.keys.collect{|id| ContractPlan.find_by_id(id)}
    selected_contract_plans.each {|plan| ContractPlanDiscount.create(:discount_id=>self.id, :contract_plan_id=>plan.id)}
  end

  def update_group_contract_plan_discounts
    GroupContractPlanDiscount.find_all_by_discount_id(self.id).each {|plan| plan.delete}
    selected_contract_plans = group_plan_list.nil? ? [] : group_plan_list.keys.collect{|id| GroupContractPlan.find_by_id(id)}
    selected_contract_plans.each {|plan| GroupContractPlanDiscount.create(:discount_id=>self.id, :group_contract_plan_id=>plan.id)}
  end

  def update_contract_plan_features
    ContractPlanFeature.find_all_by_feature_id(self.id).each {|plan| plan.delete}
    addon_contract_plans = addon_plan_list.nil? ? [] : addon_plan_list.keys.collect{|id| ContractPlan.find_by_id(id)}
    selected_contract_plans = plan_list.nil? ? [] : plan_list.keys.collect{|id| ContractPlan.find_by_id(id)}
    selected_contract_plans.each {|plan| 
      addon = addon_contract_plans.index(plan) ? true : false
      ContractPlanFeature.create(:feature_id=>self.id, :contract_plan_id=>plan.id, :addon=>addon , :quantity=>feature_quantity[plan.id.to_s] )
    }
  end

  def update_group_contract_plan_features
    GroupContractPlanFeature.find_all_by_feature_id(self.id).each {|plan| plan.delete}
    addon_contract_plans = addon_group_list.nil? ? [] : addon_group_list.keys.collect{|id| GroupContractPlan.find_by_id(id)}
    selected_contract_plans = group_plan_list.nil? ? [] : group_plan_list.keys.collect{|id| GroupContractPlan.find_by_id(id)}
    selected_contract_plans.each {|plan| 
      addon = addon_contract_plans.index(plan) ? true : false
      GroupContractPlanFeature.create(:feature_id=>self.id, :group_contract_plan_id=>plan.id, :addon=>addon, :quantity=>group_feature_quantity[plan.id.to_s] )
    }
  end

end
