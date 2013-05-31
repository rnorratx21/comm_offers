class CreditNote < LedgerItem
  acts_as_credit_note
  
  default_scope :order => "id ASC"
  
  belongs_to :contract
  belongs_to :payment, :foreign_key => :ledger_item_id
  has_one :payment_type
  accepts_nested_attributes_for :line_items, :allow_destroy => true

  serialize :response
  
  delegate :recipient, :to => :payment, :if => Proc.new{ |i| i.recipient_id.nil? }
  delegate :sender_details, :to => :payment
  delegate :invoice, :to => :payment
  delegate :credit_card, :to => :payment
  
  def after_initialize
    self.status ||= "complete"
    self.payment_type_id ||= payment.payment_type_id
    self.contract_id ||= payment.contract_id
    
    logger.debug "line_items? #{self.payment.line_items.any?}"
    
    if self.payment and self.payment.line_items.any? and self.line_items.empty?
      for li in self.payment.line_items
        self.line_items.build(:quantity => li.quantity, :net_amount => (li.net_amount*-1), :description => "Refund for #{li.description}")
        # self.line_items.build(li.attributes.only("quantity", "net_amount", "description"))
      end # for line_item in payment.line_items
    end
  end
  
  before_save :update_total_amount
  def update_total_amount
    self.calculate_total_amount
  end
  
  # 
  # Charge to authorize.net
  # 
  # Note: we'll need to set up Authorize.net CIM if it's not already set up. 
  # 
  # Invokes: ActiveMerchant::Billing::AuthorizeNetCimGateway#create_customer_profile_transaction
  def refund!
    response = credit_card.credit!(total_amount_in_cents, payment.authorization)
    self.response = response
    self.description = response.message
    self.authorization = response.authorization
    if response.success?
      invoice.update_attribute(:status, "closed")
      self.status = "cleared"
      self.save!
      return true
    else
      self.status = "failed"
      for item in self.line_items
        item.amount = 0
      end
      self.save!
      return false
    end
  end
  
end
