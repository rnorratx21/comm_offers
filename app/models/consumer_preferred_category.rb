class ConsumerPreferredCategory < ActiveRecord::Base
  belongs_to :profile
  belongs_to :category
  
  validates_presence_of :profile_id, :category_id
  validates_uniqueness_of :category_id, :scope => :profile_id

  named_scope :by_name, :joins => :category, :order => "name asc"
  
  def value
    self.category.name if self.category
  end

end
