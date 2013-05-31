class WifiLogin < ActiveRecord::Base
  before_validation :check_contract
  validates_presence_of :contract_id
  belongs_to :contract
  belongs_to :user
  
  WIFI_SOFT_USERNAME = "demo@wifi-soft.com"
  WIFI_SOFT_PASSWORD = "demo123"
  
  WIFI_SOFT_PARAMS = %w(nasid res uamip uamport challenge called mac ip sessionid userurl)

  def featured_offer
    @featured_offer ||= begin
      if contract and contract.offers.active
        contract.offers.active.first
      end
    end
  end

  def user=(user)
    self.first_name = user.first_name unless self.first_name 
    self.last_name = user.last_name unless self.last_name 
    self.mobile_phone = user.mobile_phone unless self.mobile_phone
    self.email = user.email unless self.email
    @user = user
  end

  private 
    def check_contract
      if self.wifi_nasid
        contract = Contract.find_by_wifi_nasid(self.wifi_nasid)
        self.contract_id = contract.id if contract
      end
    end

end
