class GroupContractPlanFeature < ActiveRecord::Base
  belongs_to :group_contract_plan
  belongs_to :feature

  def amount
    read_attribute(:amount) || feature.amount
  end
end
