module ProfilePreferredLists
  attr_accessor :add_categories_list
  attr_accessor :remove_categories_list
  
  def update_preferred_categories
    if remove_categories_list and remove_categories_list.any?
      remove_categories_list.each do |pc_id|
        self.preferred_categories.find(pc_id).destroy
      end
    end
    if add_categories_list and add_categories_list.any?
      add_categories_list.each do |cat_id|
        self.preferred_categories.create(:category => Category.find(cat_id))
      end
    end
  end
  
end