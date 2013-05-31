module UserList
  attr_accessor :user_list

  
  private
  def update_users
    users.delete_all
    selected_users = user_list.nil? ? [] : user_list.keys.collect{|id| User.find_by_id(id)}
    selected_users.each {|user| self.users << user}
  end

end
