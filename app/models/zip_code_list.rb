module ZipCodeList
  attr_accessor :zip_code_list
  attr_accessor :new_zip_codes
  private
  def update_zip_codes
    self.zip_codes
    
    selected_zip_codes = zip_code_list.nil? ? [] : zip_code_list.keys.collect{|id| ZipCode.find_by_id(id)}
    unless new_zip_codes.nil?
      zips = new_zip_codes.split(',')
      zips.each do |zip_string|
        zip = ZipCode.find_by_zip_code(zip_string.strip)
        if zip
          selected_zip_codes << zip
          #Since Group is tied to Zip and Zip is tied to Ad and Ad is tied to User, Make sure the Ad follows the Zip's group and the User at least has the Group too.
          #Note that we don't enforce this on disassociate - so you could have Ads in Groups whose Zip has changed (Though when that zip gets reassigned the Ads move)
          zip.advertisers.each do |ad|
            ad.group = self
            ad.users.each do |user|
              unless user.groups.index(self)
                user.groups << self
                user.save
              end  
            end
            ad.save
          end
        else
          raise 'Zip Code not found: ' + zip_string
        end  
      end
    end
    #remove orphaned users
    self.zip_codes.each do |zip|
      unless selected_zip_codes.index(zip)
        zip.advertisers.each do |ad|
          ad.users.each do |user|
            user.groups.delete(self)
          end
        end
      end
    end
    self.zip_codes = []
    selected_zip_codes.each {|zip| self.zip_codes << zip}
    
  end

end
