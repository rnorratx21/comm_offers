module Pervasive
  
  DISABLED_PAGE_URL = "http://app.qiktag.mobi/tag.aspx?ID=931"

  def update_pervasive_page(offer)
    msg = ""
    pervasive_strings = {}
    my_logo = offer_logo(offer)
    if offer.mobile_uri #this is an edit, not a new page.

      if offer.pervasive_update_flag or offer.state_changed? or offer.headline_changed? or 
        offer.title_changed? or offer.effective_changed? or offer.disclaimers_changed? or 
        !offer.alternate_logo.blank? or offer.alternate_business_name_changed?

        @client = pervasive_client
        #   prepare_wsdl
        # end

        # unless @proxy
        #   prepare_wsdl
        # end

        puts 'editing coupon'
        msg += "CouponEdit: \n\n"
        hash = {
          # :partnerUserName => @@username, :partnerPassword => @@password, 
          :couponId => offer.mobile_id,
          :title => offer.title, 
          :description => offer.headline, 
          :additionalInfo => additional_info_text(offer), 
          :redemptionCode => nil, 
          :imageUrl => my_logo,
          :usesPerUser => 0, 
          :useDateLimits => false, 
          :startDate => '1/1/1970',
          :endDate =>'12/31/2020',
          :expireDaysAfterFirstScan => 9999,
          :mustWaitDaysToUse => 0,
          :displayInApps => (RAILS_ENV == 'production') && offer.active?,
          :locationId => 0 # pervasive to allow a zero here to just use existing location
        }
        msg += hash.inspect
        msg += "\n\n"
        # page = @proxy.CouponEdit(hash)
        page = @client.ws_call "CouponEdit", hash
        puts 'done'
      end

      if offer.active?
        @client = pervasive_client
        
        @location_changed = false
        msg += "PageEdits: \n\n"
        rh = prepare_updated_page(offer)
        rh.each do |r|
          # unless @proxy
          #   prepare_wsdl
          # end
          hash = { 
            # :partnerUserName => @@username, :partnerPassword => @@password, 
            :pageId => offer.pervasive_page_id, 
            :key=>r[0], 
            :keyUpdate => r[1], 
            # :couponId => offer.mobile_id, 
            # :OfferLogoURL => my_logo, 
            :defaultCompanyPage => true,
            :pageUrlReset => false,
            :couponOriginalId => 39, # per Rob, the template couponId  
            :couponNewId => offer.mobile_id
          }
          msg += hash.inspect
          msg += "\n\n"
          # page = @proxy.PageEdit(hash)
          page = @client.ws_call "PageEdit", hash
        end
        puts 'page edited'
      end
    elsif offer.pervasive_update_flag or offer.active? #this is a new page (if offer is active)

      # prepare_wsdl
      @client = pervasive_client
      
      org_hash = {
        # :partnerUserName=>@@username, :partnerPassword=>@@password, 
        :parentOrganizationId => 82, 
        :organizationName => offer.advertiser.name, 
        :organizationDescription=>""        
      }
      # organization = @proxy.OrganizationCreate(hash)
      organization = @client.ws_call "OrganizationCreate", org_hash
      pervasive_strings.store("mobile_org_id", organization.organizationCreateResult.to_i)
      page_hash = {
        # :partnerUserName=>@@username, :partnerPassword=>@@password, 
        :templateId=> 1039, 
        :templateOrgId=> 82, 
        :organizationId => organization.organizationCreateResult.to_i, 
        :newPageName=>offer.advertiser.name        
      }
      # page = @proxy.PageCreate(hash)
      page = @client.ws_call "PageCreate", page_hash
      pervasive_strings.store("page_uri", page.pageUrl)
      pervasive_strings.store("page_id", page.newPageId)
      puts 'page created'
      location_hash = {
        # :partnerUserName=>@@username, :partnerPassword=>@@password, 
        :locationName => offer.address.street,
        :streetAddress => offer.address.street, 
        :city => offer.address.city, 
        :streetAddress => offer.address.street, 
        :zipCode => offer.address.zip_code,
        :stateCode => offer.address.state, 
        :organizationId => organization.organizationCreateResult.to_i,
        :latitude => offer.address.lat,
        :longitude => offer.address.lng
      }
      location = @client.ws_call "LocationCreate", location_hash

      puts 'location created'
      coupon_hash = {
        # :partnerUserName=>@@username,:partnerPassword=>@@password, 
        :title => offer.title, 
        :description => offer.headline, 
        :additionalInfo => additional_info_text(offer),
        :redemptionCode => nil, 
        :imageUrl => my_logo, 
        :usesPerUser => 0, 
        :useDateLimits => false, 
        :startDate => '1/1/1970', 
        :endDate => '12/31/2020', 
        :expireDaysAfterFirstScan => 0, 
        :mustWaitDaysToUse => 0, 
        :locationId => location.locationCreateResult.to_i, 
        :organizationId => organization.organizationCreateResult.to_i, 
        :displayInApps => true
      }
      msg += "\n\nCouponCreate: \n\n"
      msg += hash.inspect
      # page = @proxy.CouponCreate(coupon_hash)
      page = @client.ws_call "CouponCreate", coupon_hash
      puts 'coupon created'
      pervasive_strings.store("coupon_id", page.couponCreateResult.to_i)
      rh = prepare_new_page(offer)
      puts 'updates prepared'
      msg += "PageEdit(s)\n\n"
      rh.each do |r|
        hash = {
           # :partnerUserName=>@@username, :partnerPassword=>@@password, 
           :pageId => pervasive_strings["page_id"], 
           :key => r[0], 
           :keyUpdate => r[1], 
           # :OfferLogoURL => my_logo, 
           # :imageUrl => my_logo, 
           :defaultCompanyPage => true,
           :pageUrlReset => false, 
           :couponOriginalId => 39,
           :couponNewId => pervasive_strings["coupon_id"]
        }
        msg += hash.inspect
        msg += "\n\n"
        # page = @proxy.PageEdit(hash)
        page = @client.ws_call "PageEdit", hash
        puts 'looped page edit completed'
     end
     puts 'done'
    end  
# puts msg.inspect
    # pervasive_strings["msg"] = msg.gsub(@@password, "<FILTERED>")
    return pervasive_strings
  end


  private

  # def prepare_wsdl
  #   require 'soap/wsdlDriver'
  #   wsdl_url = 'http://app.qiktag.mobi/Services/QikTagFunctions.asmx?WSDL'
  #   @proxy = SOAP::WSDLDriverFactory.new(wsdl_url).create_rpc_driver
  #   @proxy.endpoint_url='http://app.qiktag.mobi/Services/QikTagFunctions.asmx'
  # end
  
  def prepare_new_page(offer)
    rh ={}
    rh.store("ExtraInfoHeader", offer.business_name || "")
    format_desc = format_description(offer.description.clone)
    # while format_desc.index("\r\n")
    #   format_desc.sub!("\r\n", "<br>")
    # end
    rh.store("ExtraInfoText", format_desc || "")
    rh.store("StandardInfoHours", offer.hours || "") 
    rh.store("StandardInfoPhone", offer.phone_number || "") 
    rh.store("StandardInfoPayment", offer.payment_methods_text || "") 
    rh.store("StandardInfoExpires", offer.expires_on || "") 
    rh.store("StandardInfoSMS", offer.sms_marketing_info || "") 
    rh.store("FacebookLink", offer.facebook_url ||  "http://www.facebook.com/pages/CommunityOffers/176643562398") 
    rh.store("FacebookLikeLink", facebook_like_link(offer) || "") 
    rh.store("TwitterHandle", offer.twitter_url || "http://twitter.com/communityoffers") 
    rh.store("MapHeader", offer.address.street)
    rh.store("MapStreet", offer.address.street)
    rh.store("MapCity", offer.address.city)
    rh.store("MapZip", offer.address.zip_code)
    rh.store("StandardInfoAddress", offer.address.full)
    rh.store("OfferLogoURL", offer_logo(offer))
    return rh
  end
  
  def prepare_updated_page(offer)
    rh={}
    old_offer = Offer.find(offer.id)
    if offer.pervasive_update_flag or (old_offer.business_name != offer.business_name)
      rh.store("ExtraInfoHeader", offer.business_name  || "")
    end
    if offer.pervasive_update_flag or offer.description_changed?
      format_desc = format_description(offer.description.clone)
      # old_format_desc = format_description(old_offer.description.clone)
      rh.store("ExtraInfoText", format_desc  || "")
    end
    if offer.pervasive_update_flag or offer.hours_changed?
      rh.store("StandardInfoHours", offer.hours  || "")
    end
    if offer.pervasive_update_flag or (offer.address && offer.address.phone_number_changed?)
      rh.store("StandardInfoPhone", offer.address.phone_number  || "")
    end
    if offer.pervasive_update_flag or (old_offer.payment_methods_text != offer.payment_methods_text)
      rh.store("StandardInfoPayment", offer.payment_methods_text  || "") 
    end
    if offer.pervasive_update_flag or offer.expires_on_changed?
      rh.store("StandardInfoExpires", offer.expires_on  || "") 
    end
    if offer.pervasive_update_flag or offer.sms_marketing_info_changed?
      rh.store("StandardInfoSMS", offer.sms_marketing_info  || "") 
    end
    if offer.pervasive_update_flag or offer.advertiser.facebook_url_changed?
      rh.store("FacebookLink", offer.facebook_url  || "http://www.facebook.com/pages/CommunityOffers/176643562398") 
    end
    if offer.pervasive_update_flag or offer.advertiser.twitter_url_changed?
      rh.store("TwitterHandle", offer.twitter_url  || "http://twitter.com/communityoffers") 
    end

    # if logo has changed
    old_logo = offer_logo(old_offer)
    logo = offer_logo(offer)
    if offer.pervasive_update_flag or (old_logo != logo)
      rh.store("OfferLogoURL", logo)
    end

    if offer.pervasive_update_flag or offer.address.new_record? or offer.offer_address.changed? or (offer.address != offer.offer_address)
      rh.store("MapHeader" , offer.offer_address.street  || "") 
      rh.store("MapStreet" , offer.offer_address.street  || "") 
      rh.store("MapCity" , offer.offer_address.city  || "") 
      rh.store("MapZip" , offer.offer_address.zip_code  || "") 
      rh.store("StandardInfoAddress", offer.offer_address.full  || "")

    end
    return rh
  end
  
  def disable_pervasive_page(offer)
    # prepare_wsdl
    @client = pervasive_client
    hash = {
      # :partnerUserName=>@@username,:partnerPassword=>@@password, 
      :accountID=>82, 
      :pageId=> offer.pervasive_page_id, 
      :newPageUrl=>DISABLED_PAGE_URL
    }
    page = @client.ws_call 'ModifyPageLink', hash
  end
  def enable_pervasive_page(offer)
    # prepare_wsdl
    @client = pervasive_client
    hash = {
      # :partnerUserName=>@@username,:partnerPassword=>@@password, 
      :accountID=>82, 
      :pageId=> offer.pervasive_page_id, 
      :newPageUrl=>""
    }
    page = @client.ws_call 'ModifyPageLink', hash
  end

  def offer_logo(offer)    
    if offer.logo && offer.logo.normal
      unless offer.alternate_logo.blank?
        # There could be timing issues during conversion, so send the ultimate filepath
        return "http://communityoffers.com/#{offer.alternate_logo.store_dir}/#{offer.alternate_logo.file.filename}"
      end
      return "http://communityoffers.com#{offer.logo.normal.url}"
    end  
    "http://communityoffers.com/images/community_offers_logo.gif"
  end
  
  def format_description(text)
    while text.index("\r\n")
      text.sub!("\r\n", "<br>")
    end
    textilize(text)
  end

  def additional_info_text(offer)
    offer.pervasive_additional_info_text
  end

  def facebook_like_link(offer)
    %{<iframe src="http://www.facebook.com/plugins/like.php?href=http://www.communityoffers.com#{offer_link(offer)}&layout=standard&show_faces=false&width=450&action=like&colorscheme=light&height=35" scrolling="no" frameborder="0" style="border:none; overflow:hidden; height:35px;" allowtransparency="true"></iframe>}
  end  
  
  def offer_link(offer)
    "/coupon/#{offer.city_as_permalink}/#{offer.category_as_permalink}/#{offer.permalink}" rescue "/offers/##{offer.id}"
  end
  
  def pervasive_client
    @client ||= PervasiveClient.new
  end
end
