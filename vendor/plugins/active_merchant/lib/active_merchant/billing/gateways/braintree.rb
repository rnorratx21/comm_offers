require File.join(File.dirname(__FILE__),'smart_ps.rb')
module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class BraintreeGateway < SmartPsGateway
      def api_url 
        'https://secure.braintreepaymentgateway.com/api/transact.php'
      end
    
      self.supported_countries = ['US']
      self.supported_cardtypes = [:visa, :master, :american_express, :discover]
      self.homepage_url = 'http://www.braintreepaymentsolutions.com'
      self.display_name = 'Braintree'
      self.default_currency = 'USD'
    end
  end
end

