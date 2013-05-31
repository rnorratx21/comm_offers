class SalesReport
  include Validatable
  attr_reader :range_start, :range_end, :salesperson_id, :sales_area_id, :statuses #, :totals
  validates_each :range_end, :logic => lambda { 
    errors.add(:range_end, "Date range can only be 30 days long") if range_end.blank? or range_start.blank? or (@range_end-@range_start).round > 30 
  }
  validates_each :statuses, :logic => lambda { 
    errors.add(:statuses, "Please choose at least one status") unless (@statuses and @statuses.any?) 
  }

  def self.new_with_defaults
    new(
      :range_start => (Date.today-7.days).to_s,
      :range_end => (Date.today).to_s,
      :statuses => %w(closed pending)
    )
  end

  def initialize(params={})
    # Default to last week
    @range_start = Date.parse(params[:range_start]) if params[:range_start]
    @range_end = Date.parse(params[:range_end]) if params[:range_end]
    @statuses = params[:statuses]
    add_param(params, :salesperson_id)
    add_param(params, :sales_area_id)
    run if params[:run]
  end

  def run 
    invoices and totals
  end

  def invoices
    return [] unless valid? 
    @invoices ||= begin
      invoices = Invoice.by_date_range(@range_start,@range_end)
      invoices = invoices.by_statuses(@statuses)
      invoices = invoices.by_salesperson(@salesperson_id) if @salesperson_id
      invoices = invoices.by_sales_area(@sales_area_id) if @sales_area_id
      invoices
    end
    @invoices
  end

  def add_param(params, name)
    eval("@#{name.to_s} = params[:#{name}] unless params[:#{name}].blank? or params[:#{name}] == 'all' ")
  end

  def totals
    @totals ||= begin
      @totals = {:by_area => {}, :by_salesperson => {}}
      invoices.each do |i|
        add_invoice_to_total(:sales_area, i)
        add_invoice_to_total(:salesperson, i)
      end
      @totals
    end
    @totals
  end

  def total_for(key, obj)
    @totals[key][obj.id]
  end

  def as_arrays
    @as_array ||= begin
      invoices.collect do |invoice|
        [invoice.contract.id,
          invoice.id,
          invoice.contract.advertiser.name,
          "#{invoice.contract.salesperson.display_name rescue ''}",
          "#{invoice.contract.sales_area.name rescue ''}",
          invoice.due_date,
          invoice.status,
          invoice.total_amount.to_i,
          payment_text(invoice)
        ]
      end
    end
    csv_headers.concat @as_array
  end
  
  def csv_headers
    [%w(contract_id invoice_id advertiser salesperson sales_area due_date status total tc_authorizations)]
  end
  
  def add_invoice_to_total(key, invoice)
    id = eval("invoice.contract.#{key.to_s}_id")
    if id
      @totals[key] = {} unless @totals[key]
      sum=@totals[key][id]
      sum = sum ? (sum+invoice.total_amount.to_f) : invoice.total_amount.to_f
      @totals[key][id] = sum
    end
  end
  
  def payment_text(invoice)
    invoice.payments.collect{|pmt| pmt.authorization }.join(', ') 
  end
  
end