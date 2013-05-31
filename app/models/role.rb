class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :role_activity_concepts
  act_as_type
  
  
  after_save :update_activity_concepts
  include ActivityConceptList
  
  after_save :update_users
  include UserList
  
end
