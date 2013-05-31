module Billing
  
  gateway_config = YAML.load_file("#{RAILS_ROOT}/config/gateway.yml")[RAILS_ENV]
  
  GATEWAY = ActiveMerchant::Billing::Base.gateway(gateway_config["gateway"]).new(
    :login => gateway_config["username"],
    :password => gateway_config["password"]
  )
  
  ActiveMerchant::Billing::Base.mode = gateway_config["mode"].intern
  
end

