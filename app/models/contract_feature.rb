class ContractFeature < ActiveRecord::Base
  belongs_to :contract
  belongs_to :feature
end
