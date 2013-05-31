module BillingHelper
  
  def render_payment(payment)
    payment.render_html(:quantity_column => true) do |i|
      i.invoice_label "Payment Advice"
    end
  end
  
  def render_invoice(invoice, invoice_label="Invoice")
    invoice.render_html(:quantity_column => true ) do |i|
      i.invoice_label invoice_label
      i.sender_tax_number nil
      i.recipient_tax_number nil
    end
  end
  
end
