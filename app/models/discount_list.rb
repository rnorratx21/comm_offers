module DiscountList
  attr_accessor :discount_list

    
  private


  def update_contract_plan_discounts
    ContractPlanDiscount.find_all_by_contract_plan_id(self.id).each {|plan| plan.delete}
    selected_discounts = discount_list.nil? ? [] : discount_list.keys.collect{|id| Discount.find_by_id(id)}
    selected_discounts.each {|plan| ContractPlanDiscount.create(:discount_id=>plan.id, :contract_plan_id=>self.id)}
  end

  def update_group_contract_plan_discounts
    GroupContractPlanDiscount.find_all_by_group_contract_plan_id(self.id).each {|plan| plan.delete}
    selected_discounts = discount_list.nil? ? [] : discount_list.keys.collect{|id| Discount.find_by_id(id)}
    selected_discounts.each {|plan| GroupContractPlanDiscount.create(:discount_id=>plan.id, :group_contract_plan_id=>self.id)}
  end



end
