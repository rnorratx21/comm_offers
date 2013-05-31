class BillingNotifier < MadMimiMailer
  
  def mimi_invoice_paid(payment)
    subject "[CommunityOffers] Your Invoice"
    recipients payment.invoice.advertiser.users.collect(&:email)
    from "support@communityoffers.com"
    promotion 'invoice'
    body :invoice_html => render_invoice(payment), :reason => "Thank You!"
  end

  def mimi_invoice_failed(payment)
    subject "[CommunityOffers] Payment Failed"
    recipients payment.invoice.advertiser.users.collect(&:email)
    from "support@communityoffers.com"
    promotion 'invoice'
    body :invoice_html => render_invoice(payment), :reason => %Q{<span style="color:red">#{payment.description}</span>}
  end
  
  def render_invoice(invoice, invoice_label="Payment Advice")
    invoice.render_html(:quantity_column => true ) do |i|
      i.invoice_label invoice_label
      i.sender_tax_number nil
      i.recipient_tax_number nil
    end
  end
  
end
