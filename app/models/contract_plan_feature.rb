class ContractPlanFeature < ActiveRecord::Base
  belongs_to :contract_plan
  belongs_to :feature

  def amount
    read_attribute(:amount) || feature.amount
  end
end
