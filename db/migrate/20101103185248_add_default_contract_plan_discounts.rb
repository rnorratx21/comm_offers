class AddDefaultContractPlanDiscounts < ActiveRecord::Migration
  PROMO_CODE = "2011SPECIAL"
  def self.up
    discount = Discount.create(
      :promo_code => PROMO_CODE, 
      :amount_off => 100,
      :months => 3,
      :setup_display => true,
      :description => "$100 off advanced plans!")
    ContractPlan.find_by_system_key("platinum").contract_plan_discounts.create(:discount => discount)
    ContractPlan.find_by_system_key("diamond").contract_plan_discounts.create(:discount => discount)
  end

  def self.down
    Discount.find_by_promo_code(PROMO_CODE).destroy
  end
end
