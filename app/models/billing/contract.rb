class Contract < ActiveRecord::Base
  # Extend the class with builder methods for contract templates
  extend ContractBuilder
  
  belongs_to :advertiser
  belongs_to :contract_plan
  belongs_to :group_contract_plan  
  has_one :contract_discount
  has_one :credit_card
  has_many :contract_features
  belongs_to :salesperson, :class_name => "User"
  belongs_to :sales_manager, :class_name => "User"
  belongs_to :sales_area
  
  # This contract can cover one or more offers: 
  has_many :offers, :dependent => :nullify
  has_many :active_offers, :class_name => 'Offer', :conditions => ["state = 'active'"]
  # Invoices and Payments
  #
  # For a completed 12-month contract, this contract would have
  # * 12 invoices
  # * 12 payments
  has_many :invoices, :class_name => "Invoice", :dependent => :destroy
  has_many :payments, :class_name => "Payment", :dependent => :destroy
  has_many :credit_notes, :dependent => :destroy
  
  has_many :wifi_logins
  has_many :wifi_udps
  attr_accessor :bypass_code_param

  accepts_nested_attributes_for :credit_card
  accepts_nested_attributes_for :invoices, :allow_destroy => true
  accepts_nested_attributes_for :payments
  
  # before_save :set_advertiser
  validates_presence_of :advertiser, :on => :create, :message => "can't be blank"
  
  named_scope :draft,  :conditions => ["contracts.is_draft = true"]
  named_scope :active, :conditions => ["contracts.is_draft = false"]
  # column sorting in admin's view
  named_scope :ordered_by, lambda { |order| { 
    :include => :advertiser,
    :joins => "left join advertisers A ON contracts.advertiser_id = A.id", 
    :select => 'contracts.*, A.name AS advertiser_name',
    :order => order 
  } }
  named_scope :by_group, lambda { |group_ids| ( group_ids.index(Group::GLOBAL.id)) ? {} :  { 
    :joins=>:advertiser, :conditions => ["(advertisers.group_id IN (?) and advertisers.group_id != ?)  ", group_ids, Group::DEFAULT.id] } }
  # search in admin's view
  named_scope :advertiser_or_offer_name_like, lambda { |query| { 
  	:conditions => ["A.name LIKE ? OR contracts.notes LIKE ? OR (contracts.id IN (SELECT contract_id FROM offers WHERE title LIKE ?)) OR (contracts.advertiser_id IN (SELECT advertiser_id FROM users WHERE email LIKE ?))", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%"] 
  	} if query && query.length > 0 
  }
  named_scope :for_csv, :conditions => ["contracts.is_draft = false"]
  named_scope :with_wifi, :conditions => ["wifi_nasid IS NOT NULL"]
  
  def self.build_from_defaults
    new do |c|
      c.is_draft = true
      c.contract_plan = ContractPlan.default.first if ContractPlan.default.any?
      if discount = Discount.default.first
        c.build_contract_discount(:discount => discount)
      end
    end
    # contract.contract_plan = if ContractPlan.default.first
  end

  def file=(uploaded_file)  
    @uploaded_file = uploaded_file
    @filename = sanitize_filename(@uploaded_file.original_filename)
    write_attribute("content_type", @uploaded_file.content_type)
    write_attribute("file", path_to_file)
  end

  def recipient
    advertiser
  end
  
  def after_create
    create_file if file
  end

  def after_update
    create_file if file
  end

  def after_destroy
    if self.file and File.exists?(self.file)
      File.delete(self.file)
      Dir.rmdir(File.dirname(self.file))
    end
  end

  def path_to_file
    File.expand_path("#{RAILS_ROOT}/upload/#{@filename}")
  end

  def sanitize_filename(file_name)
    # get only the filename, not the whole path (from IE)
    just_filename = File.basename(file_name) 
    # replace all none alphanumeric, underscore or perioids with underscore
    just_filename.gsub(/[^\w\.\_]/,'_') 
  end
  
  # From the Invoicing library (http://invoicing.rubyforge.org/doc)
  # documentation: 
  # 
  # Invoices and Credit Notes are the important documents for tax
  # purposes in most jurisdictions. They record the date on which the
  # sale is officially made, and that date determines which tax rates
  # apply. An invoice often also represents the transfer of ownership
  # from the supplier to the customer; for example, if you ask your
  # customers to send payment in advance (such as ‘topping up’ their
  # account), that money still belongs to your customer until the point
  # where they have used your service, and you have charged them for
  # your service by sending them an invoice. You should only invoice
  # them for what they have actually used, then the remaining balance
  # will automatically be retained on their account.
  # 
  # Payments are just what it says on the tin — the transfer of money
  # from one hand to another. A payment may occur before an invoice is
  # issued (payment in advance), or after/at the same time as an
  # invoice is issued to settle the debt (payment in arrears, giving
  # your customers credit). You can choose whatever makes sense for
  # your business. Payments may often be associated one-to-one with
  # invoices, but not necessarily — an invoice may be paid in
  # instalments, or several invoices may be lumped together to one
  # payment. Your customer may even refuse to pay some charges, in
  # which case there is an invoice but no payment (until at some point
  # you either reverse it with a credit note, or write it off as bad
  # debt, but that‘s beyond our scope right now).
  
  
  # Store the customer's billing info in Authorize.net
  # This would invoke 
  # ActiveMerchant::Billing::AuthorizeNetCimGateway#create_customer_profile
  # 
  # Input Elements for createCustomerProfileRequest
  # From: http://www.authorize.net/support/CIM_XML_guide.pdf
  # This function is used to create a new customer profile along with any
  # customer payment profiles and customer shipping addresses for the customer
  # profile.
  # def store_credit_card(card)
  #   self.credit_card = card
  #   card.store!
  # end
  
  # attr_accessor :credit_card_attributes
  # 
  # before_save :store_credit_card_attributes
  # def store_credit_card_attributes
  #   store_credit_card(CreditCard.new(credit_card_attributes)) if credit_card_attributes
  # end
  
  # The total of all expected payments
  def total
    invoices.collect{|i| i.total_amount or i.calculate_total_amount}.sum
  end
  
  def total_formatted(options={})
    Invoicing::CurrencyValue::Formatter.format_value("USD", total, options)
  end
  
  # The total amount paid so far
  def total_paid
    payments.collect{|i| i.total_amount or i.calculate_total_amount}.sum + credit_notes.collect{|i| i.total_amount or i.calculate_total_amount}.sum
  end
  def total_paid_formatted(options={})
    Invoicing::CurrencyValue::Formatter.format_value("USD", total_paid, options)
  end
  
  def total_outstanding
    total - total_paid
  end
  def total_outstanding_formatted(options={})
    Invoicing::CurrencyValue::Formatter.format_value("USD", total_outstanding, options)
  end
  alias_method :outstanding, :total_outstanding
  alias_method :outstanding_formatted, :total_outstanding_formatted

  def total_balance_due
    total_invoice_amount(self.invoices.past_due | self.invoices.unpaid_due_today)
  end

  def total_balance_due_formatted(options={})
    Invoicing::CurrencyValue::Formatter.format_value("USD", total_balance_due, options)
  end
  
  def next_invoice
    # invoices.unpaid.first
    invoices.first
  end
  
  def pay!
    next_invoice.pay!
  end

  # c.total_amount c.invoices.past_due
  def total_invoice_amount(items)
	  (items.collect { |item| item[:total_amount] }).inject { |sum, total_amount| sum + total_amount }

  end

  def has_balance_due?
    self.invoices.past_due.any? or self.invoices.unpaid_due_today.any?
  end

  # def set_advertiser
  #   self.advertiser ||= offers.first.advertiser
  # end
  
  def feature_adjustment
    total = 0
    self.contract_features.each do |f|
      if f.feature.amount
        total += f.feature.amount
      end
    end
    return total
  end

  def discount
    #check for amount off or percent off, and duration
    if self.contract_discount
      self.contract_discount.discount
    end
  end
  
  def process_signup_payment_and_activate #(credit_card)
    feedback = []
    self.credit_card.save if self.credit_card.new_record? # stores in authorize.net
    invoice = self.invoices.first
    unless invoice.pay!
      feedback << invoice.payments.last.description
    end
    activate
    feedback
  end

  def activate
    self.update_attributes(:is_draft => false)
  end

  # def bypass_payment?(contract_params)
  #   self.bypass_code_param = contract_params[:bypass_code_param]
  #   unless self.contract_plan.payment_bypass_code.blank?
  #     if self.contract_plan.payment_bypass_code == self.bypass_code_param
  #       if contract_params[:upgrade_request_date]
  #         self.upgrade_request_date = Date.parse(contract_params[:upgrade_request_date])
  #       end
  #       activate
  #       return save
  #     end
  #     errors.add(:bypass_code_param, "The payment code you entered was not correct.")
  #   end
  #   false
  # end

  def suggested_sales_area
    if advert=self.advertiser
      # offer = self.offers.last
      if advert.address and zc = advert.address.zip_code_obj
        zc.sales_area
      end
    end
  end

  def csv_excludes
    %w(content_type file group_contract_plan_id is_draft platinum)
  end

  def has_wifi?
    self.wifi_nasid
  end

  def wifi_counts(attr)
    self.wifi_logins.count(:group => attr.to_s, :order => 'count_all desc')
  end

  private
    def create_file
        if !File.exists?(File.dirname(path_to_file))
          Dir.mkdir(File.dirname(path_to_file))
        end
        if @uploaded_file.instance_of?(Tempfile)
          FileUtils.copy(@uploaded_file.local_path, path_to_file)
        else
          File.open(self.path_to_file, "wb") { |f| f.write(@uploaded_file.read) }
        end
    end
end
