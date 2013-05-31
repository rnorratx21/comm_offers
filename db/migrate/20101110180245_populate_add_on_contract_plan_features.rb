class PopulateAddOnContractPlanFeatures < ActiveRecord::Migration
  def self.up
    # Add-On Features
    addl_zip_block = Feature.find_by_system_key("addl_zip_block")
    city_zips = Feature.find_by_system_key("city_zips")
    your_qr = Feature.find_by_system_key("your_qr")
    sms = Feature.find_by_system_key("sms")

    # Assign Add-Ons to Plans
    gold = ContractPlan.find_by_system_key("gold")
    gold.contract_plan_features.create(:feature => addl_zip_block, :addon => true)
    gold.contract_plan_features.create(:feature => city_zips, :addon => true)
    gold.contract_plan_features.create(:feature => your_qr, :addon => true)
    gold.contract_plan_features.create(:feature => sms, :addon => true)

    platinum = ContractPlan.find_by_system_key("platinum")
    platinum.contract_plan_features.create(:feature => addl_zip_block, :addon => true)
    platinum.contract_plan_features.create(:feature => city_zips, :addon => true)
    platinum.contract_plan_features.create(:feature => your_qr, :addon => true)
    platinum.contract_plan_features.create(:feature => sms, :addon => true)

    diamond = ContractPlan.find_by_system_key("diamond")
    diamond.contract_plan_features.create(:feature => addl_zip_block, :addon => true)
    diamond.contract_plan_features.create(:feature => city_zips, :addon => true)
  end

  def self.down
  end
end
