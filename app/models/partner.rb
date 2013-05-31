class Partner < ActiveRecord::Base
  validates_presence_of :name, :username, :password
  validates_uniqueness_of :username
  before_create :ensure_token

  has_many :offer_mappings, :class_name => "PartnerOfferMapping"

  def password_match?(pw)
    pw == self.password unless pw.blank?
  end

  def ensure_token
    self.token ||= generate_token
  end

  def generate_token
    ActiveSupport::SecureRandom.hex(16)
  end
end
