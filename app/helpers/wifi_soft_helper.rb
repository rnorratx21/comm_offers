module WifiSoftHelper

  def is_wifi_linked_to_merchant?
    @wifi_login and @wifi_login.contract
  end
end
