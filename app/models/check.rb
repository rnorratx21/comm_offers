class Check
  include Validatable

  attr_accessor :first_name, :last_name

  def initialize(params=nil)
    params.each { |name, value| send("#{name}=", value) } if params
  end

  validates_presence_of :first_name
  validates_presence_of :last_name
end
