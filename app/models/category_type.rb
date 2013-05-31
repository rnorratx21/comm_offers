# == Schema Information
#
# Table name: category_types
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CategoryType < ActiveRecord::Base
  has_many :categories, :order => "name ASC"

  named_scope :by_name, :order => "name ASC"
end
