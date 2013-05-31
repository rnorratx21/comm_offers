module ApiHelper
  def api_salutation
    return "#{current_user.first_name} #{current_user.last_name.first}." if current_user
    return current_partner.name
    ""
  end
  
  def api_sign_out_link
    text = "Sign Out"
    link_to text, logout_path if current_user
    link_to text, partners_logout_path if current_partner
  end

  def api_flash
    str = ""
    if flash.any?
      str += flash[:notice].to_s
      str += flash[:error].to_s
    end
    str
  end
  
  def api_flash_class
    str = "alert "
    return str += 'alert-info' if flash[:notice]
    return str += 'alert-error' if flash[:error]
  end

end
