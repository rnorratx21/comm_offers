# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def mobile_community_offers_path
    "http://app.qiktag.mobi/tag.aspx?ID=265"
  end

  def co_logo
    image_tag('community_offers_logo_horiz.png')
  end

  # include ActiveSupport::CoreExtensions::String::Inflections
  def ago(time)
    if time > Time.now
      "from now"
    else
      "ago"
    end
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)", :class => "remove_fields")
  end
  
  def head_text(text)
    content_for :pageHead do
      "<div id='headerWrap'><h1>#{text}</h1></div>"
    end
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"), :class => "add_fields")
  end
  
  def will_paginate(collection)
    if collection.total_pages > 1
      content_for(:content_footer) do
        content_tag(:div, :class => "paginator rounded {bottom}") do
          super collection
        end
      end
    end
  end
  
  def button_for(name, options={})
    options = {
      :button_type => :submit
    }.update(options)
    return content_tag(:button, content_tag(:span, content_tag(:span, name)), :class => options[:class], :type => options[:button_type])
  end

  def main_tab_link(name, path, active_override=nil)
    html_options = {}
    html_options[:class] = "activeMainNav" if active_override or (active_override.nil? and current_page?(path))
    link_to name, path, html_options
  end

  def body_id(id=nil)
    @body_id = id if id
    @body_id ||= page_id
  end
  
  # def body_class
  #   return home if request.path == root_path
  #   # params[:controller].split("/").first
  # end
  
  def page_id
    c = controller.class.to_s.underscore.gsub(/_controller$/, '').gsub("/","_")
    a = controller.action_name.underscore
    "#{c}_#{a}"
  end

  def inline_model_label(value)
    content_tag :span, value, :class => "model_label"
  end
  
  def model_label(value)
    "#{inline_model_label(value)}<br />"
  end
  
  def model_data(value)
    if value != nil
      content_tag :span, value, :class => "model_data"
    else
      ""
    end
  end
  
  def stacked_model_data(value)
    if not value.blank? # != nil
      "#{model_data(value)}<br />"
    else
      ""
    end
  end
  
  def model_name(value)
    "<span class=\"model_name\">#{CGI.escapeHTML(value)}</span>"
  end
  
  def model_attribute(object, method, options={})
    label = options.delete(:label) || method.to_s.humanize.titleize
    css_class = options.delete(:class)
    format = options.delete(:format)

    data = object.send method
    data = data.strftime(format) if format
    
    label_markup = content_tag :span, label, options.merge(:class => "model_label")
    data_markup = content_tag :span, data, options.merge(:class => "model_data")
    
    content_tag :p, "#{label_markup}<br />#{data_markup}", options.merge(:class => "model_data #{css_class}".rstrip)
  end
  
  def marker_letter(i)
    (?A+i).chr
  end
  
  def marker_icon(options={})
    letter = options[:letter]
    kind = options[:kind]

    dot_url = "http://maps.google.com/mapfiles/marker.png"
     small_dot_url = image_path "small_marker.png"
    letter_url = "http://maps.google.com/mapfiles/marker#{letter}.png"

    return small_dot_url if kind == :service_area
    return letter_url if letter
    return dot_url
  end
  
  def marker_tag(options={})
    image_tag marker_icon(options), :class => "marker_icon", :alt => options[:letter]
  end

  def marker_link_tag(options={})
    link_to marker_tag(options), "javascript:void(0);"
  end

  def state_select_options
    [   
      ['Select a State', nil],
      ['Alabama', 'AL'], 
      ['Alaska', 'AK'],
      ['Arizona', 'AZ'],
      ['Arkansas', 'AR'], 
      ['California', 'CA'], 
      ['Colorado', 'CO'], 
      ['Connecticut', 'CT'], 
      ['Delaware', 'DE'], 
      ['District Of Columbia', 'DC'], 
      ['Florida', 'FL'],
      ['Georgia', 'GA'],
      ['Hawaii', 'HI'], 
      ['Idaho', 'ID'], 
      ['Illinois', 'IL'], 
      ['Indiana', 'IN'], 
      ['Iowa', 'IA'], 
      ['Kansas', 'KS'], 
      ['Kentucky', 'KY'], 
      ['Louisiana', 'LA'], 
      ['Maine', 'ME'], 
      ['Maryland', 'MD'], 
      ['Massachusetts', 'MA'], 
      ['Michigan', 'MI'], 
      ['Minnesota', 'MN'],
      ['Mississippi', 'MS'], 
      ['Missouri', 'MO'], 
      ['Montana', 'MT'], 
      ['Nebraska', 'NE'], 
      ['Nevada', 'NV'], 
      ['New Hampshire', 'NH'], 
      ['New Jersey', 'NJ'], 
      ['New Mexico', 'NM'], 
      ['New York', 'NY'], 
      ['North Carolina', 'NC'], 
      ['North Dakota', 'ND'], 
      ['Ohio', 'OH'], 
      ['Oklahoma', 'OK'], 
      ['Oregon', 'OR'], 
      ['Pennsylvania', 'PA'], 
      ['Rhode Island', 'RI'], 
      ['South Carolina', 'SC'], 
      ['South Dakota', 'SD'], 
      ['Tennessee', 'TN'], 
      ['Texas', 'TX'], 
      ['Utah', 'UT'], 
      ['Vermont', 'VT'], 
      ['Virginia', 'VA'], 
      ['Washington', 'WA'], 
      ['West Virginia', 'WV'], 
      ['Wisconsin', 'WI'], 
      ['Wyoming', 'WY']
    ]
  end  
  
  def find_savings_page?
    params[:controller] == "search" || (params[:controller] == "offers" && params[:action] == "show") || (params[:controller] == "affiliate_offers" && params[:action] == "show")
  end
  
  def about_page?
    params[:controller] == "home" && params[:action] =~ /about/
  end
  
  def advertise_page?
    params[:controller] == "advertiser/signup" #|| (params[:controller] == "home" && params[:action] == "advertise")
  end

  # def gold_plan_price
  #   OrderItems::GoldPlan.default_price
  # end
  # 
  # def platinum_plan_price
  #   OrderItems::PlatinumPlan.default_price
  # end
  # 
  # def zip_code_block_price
  #   OrderItems::ZipCodeBlock.default_price
  # end
  # 
  def future?(time)
    time > Time.now ? true : false
  end
  
  def date_format(date_obj)
    return "" if date_obj.blank?
    return date_obj.to_s if date_obj.is_a?(Date)
    return date_obj.to_datetime.strftime("%m-%d-%Y") if date_obj.is_a?(ActiveSupport::TimeWithZone)
    return Date.parse(date_obj).to_s
  end
  
  def date_field(f, attribute, css_classes=nil)
    f.text_field attribute, :class=>"datepicker #{css_classes}", :size => 20, :value => f.object.send(attribute.to_sym).to_s
  end

  def required_label(form_helper, method, text=nil, options = {})
    hint_tag = options[:hint] ? "<span class='hint'>#{options[:hint]}</span>" : ""
    txt = "<span class='required'>*</span>#{text || method.to_s.humanize}#{hint_tag}"
    form_helper.label(method, txt, options.reject{|k,v|k == :hint})
  end
  
  def user_header_name
    if current_user && !current_user.first_name.blank? and !current_user.last_name.blank?
      %{<span class='salutation'>Welcome <strong>#{current_user.first_name} #{current_user.last_name[0,1]}!</strong></span>
        Not You? #{link_to "Sign In here", logout_path}.} 
    end
  end
  
  def yes_no(bool)
    bool ? "Yes" : "No"
  end
  
  def is_production?
    RAILS_ENV == 'production'
  end

  def general_inquiry_object
    @inquiry ||= Inquiry.new(:inquiry_type => 'general')
  end
  
  def android_app_path
    "https://market.android.com/details?id=com.CommunityOffersDev"
  end
  
  def iphone_app_path
    "http://itunes.apple.com/us/app/community-offers/id409605886?mt=8"
  end
  
  def not_signup_controller?
    params[:controller] != 'advertiser/signup'
  end
  
  def is_admin?
    current_user.has_admin_role? || current_user.admin?
  end
  
  def last_login
    current_user and current_user.last_login_at
  end

  def js_sort_link(name)
    link_to name, 'javascript:void(0)'
  end
end
