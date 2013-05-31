class Inquiry < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :email, :inquiry_type, :message
  validates_inclusion_of :inquiry_type, :in => %w(general investor)
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, 
    :message => " must be a valid email address.  Please double check-your entry!"

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
