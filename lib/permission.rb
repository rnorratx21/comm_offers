module Permission
 
  def has_group_permission(credentials,action_scope)
    if credentials.index(action_scope) || credentials.index(Group::GLOBAL.id)
      return true
    else
      return false
    end
  end
  
  def auth(user, concept, activity, scope = "page")
    role = user.roles[0]
    if role
      unless !RoleActivityConcept.find(:first, :conditions=> ["role_id=? and concept_id=? and activity_id = ?", role.id,concept.id,activity.id]).nil?
        return scope=="page" ? not_authorized : false
      end
      true
    else
      return scope=="page" ? not_authorized : false
    end
  end
  
  private

    def not_authorized
      flash[:notice] = "You are not authorized to do that."
      redirect_to admin_root_path
      return false      
    end
  
end
