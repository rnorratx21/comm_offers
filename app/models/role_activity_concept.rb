class RoleActivityConcept < ActiveRecord::Base
  belongs_to :role
  belongs_to :concept
  belongs_to :activity
end
