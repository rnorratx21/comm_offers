namespace :gateway do
  desc "Charge invoices due today"
  task :charge => :environment do
    
    RAILS_DEFAULT_LOGGER.info("\n\n= BEGIN rake gateway:charge")
    
    message "====="
    message "#{Invoice.open_or_pending.due_today.count} Invoices are due today, #{Date.today}"
    
    # Due today
    begin
      Invoice.open_or_pending.due_today.each do |invoice|
        begin
          if invoice.contract.active_offers.empty?
            invoice.update_attributes(:status => "skipped")
            message "* Skipping invoice http://www.communityoffers.com/admin/invoices/#{invoice.id} because there are no active offers"
          # elsif invoice.pay!
          else
            invoice.update_attributes(:status => "would_pay")
            message "* Would have attempted to pay invoice: http://www.communityoffers.com/admin/invoices/#{invoice.id}"
            # message "* Successfully paid invoice http://www.communityoffers.com/admin/invoices/#{invoice.id}"
          # else
          #   message "* ERROR: an error occurred charging invoice #{invoice.id}, trust commerce details: #{invoice.payments.last.inspect}"
          end
        rescue InvoiceException::InvoicePaid => e
          message "* NOTICE: invoice http://www.communityoffers.com/admin/invoices/#{invoice.id} was marked as already paid."
        rescue InvoiceException::NoCreditCard => e
          message "* NOTICE: invoice http://www.communityoffers.com/admin/invoices/#{invoice.id} had no credit card on file."
        rescue Exception => e
          message "FATAL ERROR on invoice #{invoice.id} occured (billing processing will continue): #{e.message} -- #{e.backtrace}"
        end
      end
      
    rescue Exception => e
      message "FATAL ERROR prevented billing task from completing: #{e.message}"
    end
    
    # Past due...
    message "\n\n====="
    message "There are #{Invoice.past_due.count} past due invoices: http://www.communityoffers.com/admin/invoices/past_due"
    
    SystemNotifier.deliver_notification("Daily Payment Report #{Date.today}", @message.join("\n"))
    RAILS_DEFAULT_LOGGER.info("\n\n= END rake gateway:charge\n\n")
    RAILS_DEFAULT_LOGGER.flush
  end
end

def message(str)
  @message ||= []
  RAILS_DEFAULT_LOGGER.info(str)
  @message << str
end