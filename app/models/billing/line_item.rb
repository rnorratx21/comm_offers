class LineItem < ActiveRecord::Base
  acts_as_line_item
  
  belongs_to :ledger_item
  validates_presence_of :quantity, :description, :net_amount
  
  acts_as_currency_value :net_amount
  delegate :currency, :to => :ledger_item
end
