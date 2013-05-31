class TestPayment 
  include Validatable

  def initialize(attributes=nil)
    attributes.each { |n,v| send("#{n}=", v) } if attributes
  end

  attr_accessor :email
  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :credit_card_number
  attr_accessor :month
  attr_accessor :year
  attr_accessor :zip_code

  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :credit_card_number
  validates_presence_of :month
  validates_presence_of :year
  validates_presence_of :zip_code

  def cheddar_check_attributes
    {
      :code => email,
      :first_name => first_name,
      :last_name => last_name,
      :email => email,
      :subscription_attributes => {
        :plan_code => "TEST_CHECK",
        :billing_first_name => first_name,
        :billing_last_name => last_name,
      }
    }
  end

  def cheddar_attributes
    {
      :code => email,
      :first_name => first_name,
      :last_name => last_name,
      :email => email,
      :subscription_attributes => {
        :plan_code => "TEST",
        :billing_first_name => first_name,
        :billing_last_name => last_name,
        :credit_card_number => credit_card_number,
        :credit_card_expiration_month => month,
        :credit_card_expiration_year => year,
        :billing_zip_code => zip_code
      }
    }
  end

  def process
    if customer.nil?
      Mousetrap::Customer.create(cheddar_attributes)
    else
      Mousetrap::Customer.update(email, cheddar_attributes)
    end
  end

  def customer
    @customer ||= Mousetrap::Customer[email]
  end
end

