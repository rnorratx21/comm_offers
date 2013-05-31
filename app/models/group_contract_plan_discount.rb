class GroupContractPlanDiscount < ActiveRecord::Base
  belongs_to :discount
  belongs_to :group_contract_plan
end
