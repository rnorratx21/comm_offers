class ConsumerPreferredZipCode < ActiveRecord::Base
  belongs_to :profile
  belongs_to :zip_code
  
  validates_presence_of :profile_id, :zip_code_id
  validates_uniqueness_of :zip_code_id, :scope => :profile_id

  def value
    zip_code ? zip_code.zip_code : ""
  end
end
