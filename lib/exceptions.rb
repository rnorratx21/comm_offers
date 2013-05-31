module InvoiceException
  class InvoicePaid < StandardError; end
  class NoCreditCard < StandardError; end
end
