class Transaction < ActiveRecord::Base
  belongs_to :offer
  serialize :params

  # See http://support.cheddargetter.com/faqs/api-8/transaction-post-hook
  # 
  # Below is an example of the (bare minimum) data sent by CG:
  # 
  # customer[code] => MILTON_WADDAMS
  # customer[id] => e5121ec6-eea8-102c-b79f-646bec60195d
  # invoice[id] => e516695e-eea8-102c-b79f-646bec60195d
  # invoice[invoiceNumber] => 3524
  # invoice[type] => subscription
  # transaction[id] => e51cb6ec-eea8-102c-b79f-646bec60195d
  # transaction[amount] => 651.85
  # transaction[transactedDatetime] => 2009-09-09T11:52:01-04:00
  # transaction[response] => approved
  # 
  # CG may also send the following:
  # 
  # transaction[parentId] (if the transaction is a credit of a previous transaction)
  # transaction[memo] (if the memo was specified)
  # transaction[responseReason] (A simple, human readable string provided if the transaction resulted in anything but 'approved')
  # 
  # The possible values for invoice[type] are 'setup' and 'subscription'
  # 
  # The possible values for transaction[response] are 'approved' and 'declined'
  def self.create_from_cheddar_getter!(params)
    customer_code = params[:customer][:code]
    transaction_at = DateTime.parse params[:transaction][:transactedDatetime]
    response = params[:transaction][:response]
    amount = params[:transaction][:amount]
    invoice_type = params[:invoice][:type]

    offer = Offer.find_by_customer_code(customer_code)

    create! :transaction_at => transaction_at, :response => response, :amount => amount, :invoice_type => invoice_type, :params => params, :offer => offer
  end
end
