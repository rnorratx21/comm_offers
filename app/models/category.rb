# == Schema Information
#
# Table name: categories
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  platinum         :boolean
#  category_type_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Category < ActiveRecord::Base
  has_many :offers
  belongs_to :category_type

  named_scope :by_name, :order => "name ASC"
  named_scope :possible_preferreds, lambda { |profile| {
    :conditions => profile.preferred_categories.any? ? ["id NOT IN (?)", profile.preferred_categories.collect{|pc| pc.category_id}] : []
  }}

  def parent_name
    category_type ? category_type.name : ""
  end

  def full_name
    "#{parent_name + ' - ' unless parent_name.blank?}#{name}"
  end
end
