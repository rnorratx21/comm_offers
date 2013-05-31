class ContractDiscount < ActiveRecord::Base
    belongs_to :contract
  belongs_to :discount
end
