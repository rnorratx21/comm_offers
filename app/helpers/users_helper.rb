module UsersHelper

  def render_tracker_percentage(gender, total)
    if total.to_f > 0
      return number_to_percentage((gender.to_f/total.to_f) * 100, :precision => 0)
    end
    "0%"
  end
  
  def coming
    "<span class='coming'> -- Coming</span>"
  end
  
  def dashboard_salutation
    if current_user.profile
      %{<span class='salutation'>Welcome Back, #{current_user.first_name}.</span> Not You? #{link_to "Sign In here", logout_path}.}
    end
  end
end
