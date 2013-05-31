require 'soap/wsdlDriver'

class PervasiveClient
  attr_reader :proxy
  USERNAME = 'communityoffers'
  PASSWORD = '*A$utre+Uxa7'
  WSDL_URL = 'http://app.qiktag.mobi/Services/QikTagFunctions.asmx?WSDL'
  
  def initialize #(args)
    prepare_wsdl
  end
  
  def prepare_wsdl
    # WSDL_URL = 'http://app.qiktag.mobi/Services/QikTagFunctions.asmx?WSDL'
    @proxy ||= SOAP::WSDLDriverFactory.new(WSDL_URL).create_rpc_driver
    @proxy.endpoint_url='http://app.qiktag.mobi/Services/QikTagFunctions.asmx'
  end

  def ws_call(method, params)
    hash = {:partnerUserName => USERNAME, :partnerPassword => PASSWORD}
    hash.merge! params
    @proxy.send(method,hash)
  end

end