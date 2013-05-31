class AddSilverAndDiamondContractPlans < ActiveRecord::Migration
  def self.up
    ContractPlan.create(
      :system_key => "diamond", 
      :name => "Diamond Plan", 
      :period => "month", 
      :due_on_day => 27, 
      :installment_amount => 249, 
      :setup_amount => 125, 
      :installments => 12,
      :discount_amount => 0,
      :is_active => true
    )
  end

  def self.down
    ContractPlan.find_by_system_key("diamond").destroy
  end
end
