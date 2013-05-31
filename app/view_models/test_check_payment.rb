class TestCheckPayment 
  include Validatable

  def initialize(attributes=nil)
    attributes.each { |n,v| send("#{n}=", v) } if attributes
  end

  attr_accessor :email
  attr_accessor :first_name
  attr_accessor :last_name

  validates_presence_of :email
  validates_presence_of :first_name
  validates_presence_of :last_name

  def cheddar_attributes
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

