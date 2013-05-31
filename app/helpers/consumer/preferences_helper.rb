module Consumer::PreferencesHelper

  def preferred_category_action_link(c)
    if pc = @profile.preferred_categories.find_by_category_id(c)
      link_to("Remove", remove_category_consumer_preferences_path(:id => pc.id), 
          :method => :delete, :confirm => "Remove #{escape_javascript(pc.value)} as a preferred category?")
    else
      link_to("Add", add_category_consumer_preferences_path(:id => c.id), 
          :method => :post, :confirm  => "Add #{escape_javascript(c.name)} as a preferred category?")
    end
  end
  
end
