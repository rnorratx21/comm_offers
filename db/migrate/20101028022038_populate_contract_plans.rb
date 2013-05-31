class PopulateContractPlans < ActiveRecord::Migration
  def self.up

    
    # c1= ContractPlan.create( :name=> "Silver", :period=> "month", :due_on_day=> 27, :installment_amount=> 0, :setup_amount=> 0, :installments=> 12,  :discount_amount=> 0)
    c2 = ContractPlan.find_by_system_key("gold") #= ContractPlan.create( :name=> "Gold", :period=> "month", :due_on_day=> 27, :installment_amount=> 49, :setup_amount=> 0, :installments=> 12,  :discount_amount=> 0)
    c3 = ContractPlan.find_by_system_key("platinum")#= ContractPlan.create( :name=> "Platinum", :period=> "month", :due_on_day=> 27, :installment_amount=> 99, :setup_amount=> 0, :installments=> 12,  :discount_amount=> 0)
    c4 = ContractPlan.find_by_system_key("diamond") #= ContractPlan.create( :name=> "Diamond", :period=> "month", :due_on_day=> 27, :installment_amount=> 249, :setup_amount=> 0, :installments=> 12,  :discount_amount=> 0)

    # ContractPlanFeature.create(:contract_plan_id => c1, :feature_id=>Feature.find_by_system_key('zip'), :quantity=>1, :addon=>false)
    # ContractPlanFeature.create(:contract_plan_id => c1, :feature_id=>Feature.find_by_system_key('info'), :addon=>false)
    
    ContractPlanFeature.create(:contract_plan_id => c2, :feature_id=>Feature.find_by_system_key('zip'), :quantity=>3, :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c2, :feature_id=>Feature.find_by_system_key('info'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c2, :feature_id=>Feature.find_by_system_key('logo'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c2, :feature_id=>Feature.find_by_system_key('link'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c2, :feature_id=>Feature.find_by_system_key('coupon'), :quantity=>3, :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c2, :feature_id=>Feature.find_by_system_key('facebook'), :addon=>false)
    
    ContractPlanFeature.create(:contract_plan_id => c3, :feature_id=>Feature.find_by_system_key('zip'), :quantity=>5, :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c3, :feature_id=>Feature.find_by_system_key('info'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c3, :feature_id=>Feature.find_by_system_key('logo'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c3, :feature_id=>Feature.find_by_system_key('link'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c3, :feature_id=>Feature.find_by_system_key('coupon'), :quantity=>5, :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c3, :feature_id=>Feature.find_by_system_key('facebook'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c3, :feature_id=>Feature.find_by_system_key('our_qr'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c3, :feature_id=>Feature.find_by_system_key('your_qr'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c3, :feature_id=>Feature.find_by_system_key('sms'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c3, :feature_id=>Feature.find_by_system_key('loyalty'), :addon=>false)    
    
    ContractPlanFeature.create(:contract_plan_id => c4, :feature_id=>Feature.find_by_system_key('zip'), :quantity=>10, :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c4, :feature_id=>Feature.find_by_system_key('info'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c4, :feature_id=>Feature.find_by_system_key('logo'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c4, :feature_id=>Feature.find_by_system_key('link'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c4, :feature_id=>Feature.find_by_system_key('coupon'), :quantity=>10, :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c4, :feature_id=>Feature.find_by_system_key('facebook'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c4, :feature_id=>Feature.find_by_system_key('our_qr'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c4, :feature_id=>Feature.find_by_system_key('your_qr'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c4, :feature_id=>Feature.find_by_system_key('sms'), :addon=>false)
    ContractPlanFeature.create(:contract_plan_id => c4, :feature_id=>Feature.find_by_system_key('loyalty'), :addon=>false)    
    
  end

  def self.down
  end
end
