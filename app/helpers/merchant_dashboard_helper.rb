module MerchantDashboardHelper

  def offer_return_link
    if current_admin_user
      link_to "Back to Offer", admin_offer_path(@offer)
    else
      link_to "Back to Dashboard", account_path
    end
  end

  def male_trackers_count
    @male_trackers_count ||= @offer.male_trackers_count
  end

  def female_trackers_count
    @female_trackers_count ||= @offer.female_trackers_count
  end

  def total_trackers_count
    @total_tracker_count ||= male_trackers_count + female_trackers_count
  end

  def mobile_qr_scans_message
    if @mobile_qr_scans
      "You've Had <span class='count'>#{pluralize(@mobile_qr_scans, '</span>Mobile QR Scan')}"
    else
      "There was a problem loading your mobile QR Scan data.  We're looking into it."
    end
  end

  def mobile_redemptions_message
    if @mobile_redemptions
      "You've Had <span class='count'>#{pluralize(@mobile_redemptions, '</span>Mobile Redemptions')}"
    else
      "There was a problem loading your mobile redemption data.  We're looking into it."
    end
  end

  def mobile_app_views_message
    if @mobile_app_views
      "You've Had <span class='count'>#{pluralize(@mobile_app_views, '</span>Mobile App Views')}"
    else
      "There was a problem loading your mobile app view data.  We're looking into it."
    end
  end

  def web_page_views_message
    if @page_views_count
      "You've Had <span class='count'>#{pluralize(@page_views_count, '</span>Page Views')}"
    else
      "There was a problem loading your page view data.  We're looking into it."
    end
  end

  def web_visitors_message
    if @visitors_count
      "You've Had <span class='count'>#{pluralize(@visitors_count, '</span>Unique Visitors')} To Your Page"
    else
      "There was a problem loading your page visitor data.  We're looking into it."
    end
  end

  def offer_report_link(offer)
    icon = image_tag 'dashboard/icon_report.png'
    str="<div class='report_link'>"
    str += link_to "#{icon}<span>View Report</span>", offer_report_merchant_dashboard_path(:offer_id => offer) 
    str += "</div>"
    raw str
  end

  def offer_badge_link(offer)
    icon = image_tag 'dashboard/icon_badge.png'
    str="<div class='badge_link'>"
    str += link_to "#{icon}<span>View Featured Merchant Badge</span>", badge_merchant_dashboard_path(:offer_id => offer) 
    str += "</div>"
    raw str
  end
  
  def offer_url_link(offer)
    permalink = build_offer_permalink_path(offer)
    link_to "http://www.commmunityoffers.com#{permalink}", permalink, :target => "_blank"
  end
end
