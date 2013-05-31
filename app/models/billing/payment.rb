class Payment < LedgerItem
  # Acts as a Payment according to the Ruby Invoicing gem
  # http://invoicing.rubyforge.org/doc/
  acts_as_payment
  
  serialize :response

  EXPORTABLE_STATUSES = %w(closed pending open cleared complete)
  accepts_nested_attributes_for :line_items, :allow_destroy => true
  belongs_to :payment_type

  delegate :recipient, :to => :invoice, :if => Proc.new{ |i| i.recipient_id.nil? }
  delegate :sender_details, :to => :invoice
  
  # belongs_to :invoice
  belongs_to :invoice, :foreign_key => :ledger_item_id
  # belongs_to :contract
  has_many :credit_notes, :foreign_key => :ledger_item_id
  
  named_scope :cleared, :conditions => {:status => "cleared"}
  named_scope :paid_on, lambda { |date| { :conditions => ["DATE_FORMAT(created_at, '%Y-%m-%d 00:00:00') = ?", date] } }
  
  named_scope :csv_exportable, :conditions => ["status in (?)", EXPORTABLE_STATUSES]

  delegate :credit_card, :to => :contract
  delegate :contract, :to => :invoice
  
  # def after_initialize
  #   self.status ||= "pending"
  #   self.contract_id ||= invoice.contract.id
  #   if invoice and invoice.line_items and self.line_items.empty?
  #     for li in invoice.line_items
  #       self.line_items.build(li.attributes.only("quantity", "net_amount", "description"))
  #     end # for line_item in invoice.line_items
  #   end
  #   
  # end
  
  attr_accessor :amount
  
  # 
  # Charge to authorize.net
  # 
  # Note: we'll need to set up Authorize.net CIM if it's not already set up. 
  # 
  # Invokes: ActiveMerchant::Billing::AuthorizeNetCimGateway#create_customer_profile_transaction
  def pay!
    response = credit_card.purchase!(total_amount_in_cents)
    self.response = response
    self.description = response.message
    self.authorization = response.authorization
# raise "credit_card.inspect #{credit_card.inspect}, self.response #{self.response.inspect}"
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
  
  after_create :deliver
  def deliver
    self.calculate_total_amount
    if status == "cleared"
      BillingNotifier.deliver_mimi_invoice_paid(self)
    else
      BillingNotifier.deliver_mimi_invoice_failed(self)
    end # if self.status == "cleared"
  end
  
  after_create :set_invoice_status
  def set_invoice_status
    if self.status == "cleared" and invoice.paid?
      invoice.update_attribute(:status, "closed")
    end # if self.status == "cleared"
  end
  
  def csv_excludes
    ["response"]
  end
end
