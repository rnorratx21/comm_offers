class Invoice < LedgerItem
  acts_as_invoice
  
  STATUSES = %w(open closed cancelled pending cleared failed) # from http://invoicing.rubyforge.org/doc/classes/Invoicing/LedgerItem.html
  accepts_nested_attributes_for :line_items, :allow_destroy => true
  
  named_scope :by_date_range, lambda{ |range_start,range_end| {
    :conditions => {:due_date => (range_start..range_end)}
  }}
  named_scope :by_salesperson, lambda { |salesperson_id| {
    :joins => [:contract],
    :conditions => ["contracts.salesperson_id = ?",salesperson_id]
  }}
  named_scope :by_sales_area, lambda { |sales_area_id| {
    :joins => [:contract],
    :conditions => ["contracts.sales_area_id = ?", sales_area_id]
  }}
  named_scope :by_statuses, lambda { |statuses| {
    :conditions => ["status IN (?)", statuses]
  }}
  named_scope :due_this_month, lambda{ { :conditions => {:due_date => (Time.now.beginning_of_day..Time.now+1.month)} } }
  named_scope :due_today, lambda{ { :conditions => {:due_date => (Time.now.beginning_of_day..Time.now.end_of_day)}, :order => "due_date ASC" } }
  named_scope :unpaid_due_today, lambda{ { :conditions => {:due_date => (Time.now.beginning_of_day..Time.now.end_of_day), :status => 'open'}, :order => "due_date ASC" } }
  named_scope :past_due,  lambda{ { :conditions => ["due_date < ? AND status = 'open'", Time.now.beginning_of_day] } }
  named_scope :closed, :conditions => {:status => "closed"}

  named_scope :by_group, lambda { |group_ids| ( group_ids.index(Group::GLOBAL.id)) ? {} : {   :joins => ["INNER JOIN contracts ON contracts.id = ledger_items.contract_id ",
                 "INNER JOIN advertisers ON advertisers.id = contracts.advertiser_id"] , :conditions => ["advertisers.group_id IS NULL or advertisers.group_id IN (?)", group_ids] } }
  
  named_scope :advertiser_or_offer_name_like, lambda { |query| { 
  	:conditions => ["A.name LIKE ? OR (contract_id IN (SELECT contract_id FROM offers WHERE title LIKE ?))", "%#{query}%", "%#{query}%"] 
  	} if query && query.length > 0 
  }

  has_many :payments, :foreign_key => :ledger_item_id
  belongs_to :contract
  has_many :offers, :through => :contract
  has_many :payment_types, :through => :payments
  
  def credit_notes
    payments.collect(&:credit_notes).flatten
  end
  
  delegate :advertiser, :to => :contract
  delegate :credit_card, :to => :contract
  delegate :recipient, :to => :contract, :if => Proc.new{ |i| i.recipient_id.nil? }
  
  def initialize(*args)
    super(*args)
    self.status ||= "open"
  end
  
  def recipient_details
    {
      :name => recipient.name,
      :address => recipient.address.street,
      :city => recipient.address.city,
      :state => recipient.address.state,
      :postal_code => recipient.address.zip_code
    }
  end
  
  def sender_details
    {
      :name => "Community Offers",
      :address => "12400 Hwy 71 West, Suite 350",
      :city => "Austin",
      :state => "Texas",
      :postal_code => "78738"
    }
  end
  
  # http://flouri.sh/2008/11/22/duplicate-joins-merge-in-rails-2-2
  # named_scope :unpaid, :conditions => "id NOT IN "
  
  def paid?
    payments_total >= calculate_total_amount
  end
  
  def payments_total
    payments.collect{|i| i.total_amount or i.calculate_total_amount}.compact.sum + credit_notes.collect{|i| i.total_amount or i.calculate_total_amount}.compact.sum
  end
  def payments_total_formatted(options={})
    Invoicing::CurrencyValue::Formatter.format_value("USD", payments_total, options)
  end
  
  def outstanding_total
    total_amount.to_f - payments_total.to_f
  end
  def outstanding_total_formatted(options={})
    Invoicing::CurrencyValue::Formatter.format_value("USD", outstanding_total, options)
  end
  
  def build_payment(*args)
    payments.build(*args)
  end
  
  # 
  # Pay by credit card
  # 
  def pay!
    raise InvoiceException::InvoicePaid if paid?
    raise InvoiceException::NoCreditCard unless credit_card
    payment = build_payment(:contract => contract)
    for item in line_items
      payment.line_items << LineItem.new(item.attributes.only("description", "amount", "quantity", "tax_amount", "net_amount"))
    end
    payment.pay!
  end
  
  # 
  # Payment by cheque or other method
  # 
  def mark_as_paid!
    payment = self.payments.build(:contract => contract)
    for item in line_items
      payment.line_items << LineItem.new(item.attributes.only("description", "amount", "quantity", "tax_amount", "net_amount"))
    end
    self.status = "closed"
    payment.save!
  end
  
  def self.array_for_quickbooks
    keys = %w(id offer_id contract_id status currency description due_date issue_date period_start period_end tax_amount total_amount created_at updated_at)
    payment_types = {} and PaymentType.all.collect{|pt| payment_types[pt.id] = pt.name }
    number_of_payment_sets = 2
    payment_fields = %w(id status payment_type authorization check_number check_date issue_date created_at updated_at)
    header_row = Array.new(keys)
    (1..number_of_payment_sets).each{|i| payment_fields.each {|f| header_row << "payment_#{i}_#{f}" }}
    rows = Array.new([header_row])
    all(:include => [:contract, :offers, :payments, :payment_types]).each do |invoice|
      row = [
        invoice.id,
        "#{invoice.contract.offers.first.id rescue ''}",
        invoice.contract_id,
        invoice.status,
        invoice.currency,
        invoice.description,
        invoice.due_date,
        invoice.issue_date,
        invoice.period_start,
        invoice.period_end,
        invoice.tax_amount.to_f,
        invoice.total_amount.to_f,
        invoice.created_at,
        invoice.updated_at
      ]
      all_payments = invoice.payments
      payments = all_payments.reject{|pmt| !Payment::EXPORTABLE_STATUSES.include?(pmt.status) }
      for i in (1..number_of_payment_sets)
        if pmt = payments[i-1]
          row.concat([
            pmt.id,
            pmt.status,
            payment_types[pmt.payment_type_id],
            pmt.authorization,
            pmt.check_number,
            "#{pmt.check_date}",
            "#{pmt.issue_date}",
            "#{pmt.created_at.to_s}",
            "#{pmt.updated_at.to_s}"
          ])
        else
          payment_fields.size.times{row << ""}
        end
      end
      rows << row
    end
    rows
  end
  
end
