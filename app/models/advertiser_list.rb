module AdvertiserList
  attr_accessor :advertiser_list
  
  private
  def update_advertisers
    self.advertisers = []
    selected_advertisers = advertiser_list.nil? ? [] : advertiser_list.keys.collect{|id| Advertiser.find_by_id(id)}
    selected_advertisers.each {|advertiser| self.advertisers << advertiser}
  end

end
