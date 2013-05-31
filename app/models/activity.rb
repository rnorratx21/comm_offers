class Activity < ActiveRecord::Base
    has_many :role_concept_activities
  has_and_belongs_to_many :concepts
  act_as_type
end
