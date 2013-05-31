class ContractPlanDiscount < ActiveRecord::Base
  belongs_to :contract_plan
  belongs_to :feature
  belongs_to :discount
end
