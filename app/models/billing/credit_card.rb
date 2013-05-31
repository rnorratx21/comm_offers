class CreditCard < ActiveRecord::Base
  belongs_to :contract, :class_name => "Contract"
  
  # include Validatable
  
  attr_accessor :number, :verification_value
  attr_accessor :zip_code

  validates_presence_of :expires_on
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :number
  validates_presence_of :verification_value
  validates_presence_of :address1
  validates_presence_of :zip_code
  
  def to_active_merchant
    @active_merchant ||= ActiveMerchant::Billing::CreditCard.new(
      :number => number,
      :first_name => first_name,
      :last_name => last_name,
      :month => (expires_on.month.to_s if expires_on),
      :year => (expires_on.year.to_s if expires_on),
      :verification_value => verification_value
    )
  end
  
  def name
    [first_name, last_name].join(" ")
  end
  
  def store_card
    Billing::GATEWAY.store(to_active_merchant,
      :billing_address => {
        :address1 => address1,
        :address2 => address2,
        :city => city,
        :state => state,
        :zip => zip
      }
    )
  end
  
  # validate :store!
  before_validation_on_create :store!
  before_validation_on_update :store!
  def store!
    return true unless RAILS_ENV == 'production'
    response = store_card
    if response.success?
      self.billing_token = response.token
      self.authorization = response.authorization
      self.display_number = to_active_merchant.display_number
      return true
    else
      RAILS_DEFAULT_LOGGER.info("CREDIT CARD STORAGE FAILURE:")
      RAILS_DEFAULT_LOGGER.info(self.inspect)
      RAILS_DEFAULT_LOGGER.info(response.inspect)
      self.errors.add_to_base response.message
      return false
    end
  end
  
  before_destroy :unstore!
  def unstore!
    Billing::GATEWAY.unstore(billing_token)
  end
  
  def purchase!(amount)
    Billing::GATEWAY.purchase(amount, billing_token)
  end
  
  def credit!(amount, transaction_id, options={})
    Billing::GATEWAY.credit(amount.abs, transaction_id, options)
  end
  
end
