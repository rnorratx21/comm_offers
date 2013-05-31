class ClosePaidInvoices < ActiveRecord::Migration
  def self.up
    for invoice in Invoice.open_or_pending
      invoice.update_attribute(:status, "closed") if invoice.paid?
    end
  end

  def self.down
  end
end
