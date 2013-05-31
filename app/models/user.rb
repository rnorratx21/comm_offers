# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)     not null
#  crypted_password   :string(255)     not null
#  password_salt      :string(255)     not null
#  persistence_token  :string(255)     not null
#  perishable_token   :string(255)     not null
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#  advertiser_id      :integer
#  admin              :boolean
#  created_at         :datetime
#  updated_at         :datetime
#

class User < ActiveRecord::Base
  acts_as_authentic
  
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :groups
  belongs_to :advertiser  
  has_many :audits, :as => :user
  has_many :tracked_offers
  has_one :profile

  validates_presence_of :first_name, :on => :create
  validates_presence_of :last_name, :on => :create

  accepts_nested_attributes_for :advertiser
  accepts_nested_attributes_for :profile
  
#Group Scopes

  named_scope :by_group, lambda { |group_ids|  group_ids.index(Group.find_by_name("Global").id) ? {} :  {  
    :conditions => ["exists (select '1' from groups_users where user_id = users.id and group_id != ? and group_id IN (?))", Group.find_by_name("Default").id, group_ids] } } 
                
  named_scope :consumer, :conditions => {:consumer => true}
  named_scope :non_consumer, :conditions => {:consumer => false}
  named_scope :assigned_to_group,  lambda { |group_id| {   :joins => ["INNER JOIN groups_users ON users.id = groups_users.user_id ",
                 "INNER JOIN groups ON groups.id = groups_users.group_id"] , :conditions => ["groups.id = ?", group_id], :readonly=>false } }
                 
  named_scope :unassigned_to_group, Group.find_by_name("Default") ? {:conditions => ["(not exists (select '1' from groups_users where user_id = users.id and group_id != ?))", Group.find_by_name("Default").id ]} : {}
    
  named_scope :assigned_to_other_group, lambda { |group_id|  { :conditions => 
    ["exists (select '1' from groups_users where user_id = users.id and group_id != ? and group_id != ?)", group_id, Group.find_by_name("Default").id ]  } }
    
# Role Scopes

  named_scope :by_role, lambda { |role_ids| { :conditions => ["exists (select '1' from roles_users where user_id = users.id and role_id IN (?))",  role_ids] } } 
                
  named_scope :assigned_to_role,  lambda { |role_id| {   :joins => ["INNER JOIN roles_users ON users.id = roles_users.user_id ",
                 "INNER JOIN roles ON roles.id = roles_users.role_id"] , :conditions => ["roles.id = ?", role_id], :readonly=>false } }
                 
  named_scope :unassigned_to_role, :conditions => ["(not exists (select '1' from roles_users where user_id = users.id ))"]
    
  named_scope :assigned_to_other_role, lambda { |role_id|  { :conditions => 
    ["exists (select '1' from roles_users where user_id = users.id and role_id != ?)", role_id]  } }

#Shared Scopes

  named_scope :not_user, lambda { |user_id| { :conditions => ["users.id != ?", user_id ] } }    
  named_scope :admins, :conditions => { :admin => true }
  #column sorting in admin's view
  named_scope :ordered_by, lambda { |order| { 
    :include => :advertiser,
    :joins => "left join advertisers A ON users.advertiser_id = A.id", 
    :select => 'users.*, A.name AS advertiser_name',
    :order => order 
  } }
  named_scope :active, :conditions => {:is_disabled => false }
  named_scope :disabled, :conditions => {:is_disabled => true }
  
  # Utiltiy method for name updates
  def self.update_name_by_email(email, first_name, last_name)
    if u=find_by_email(email)
      u.update_attributes(:first_name => first_name, :last_name => last_name)
    end
    u
  end
  
  after_save :update_group
  def update_group
    default_group = Group.find_by_name("Default")
    unless self.groups.index(default_group)
      self.groups << default_group
      self.save
    end
  end
  

  #search in admin's view
  named_scope :advertiser_or_email_like, lambda { |query| { 
  	:conditions => ["A.name LIKE ? OR email LIKE ?", "%#{query}%", "%#{query}%"] 
  	} if query && query.length > 0 
  }

  named_scope :males, 
    :joins => :profile,
    :conditions => ["profiles.is_male = true"]

  named_scope :females, 
    :joins => :profile,
    :conditions => ["profiles.is_male = false"]

  # named_scope :by_age, lambda { |start_birthdate, end_birthdate| {
  #   :joins => :profile,
  #   :conditions => ["profiles.dob <= ? AND profiles.dob >= ?", start_birthdate, end_birthdate]
  # }}

  named_scope :by_age_range, lambda { |min_age_in_years, max_age_in_years| {
    :joins => :profile,
    :conditions => ["profiles.dob <= ? AND profiles.dob >= ?", min_age_in_years.years.ago, max_age_in_years.years.ago]
  }}

  def self.salespeople
    non_consumer.by_role(Role::SALES.id, :order => "last_name asc").sort_by(&:name_for_sort)
  end

  def simple_password_reset
    if RAILS_ENV == 'development'
      self.update_attributes(:password => 'password', :password_confirmation => 'password')
    end
  end
  
  def deliver_password_reset_instructions!  
    reset_perishable_token!
    UserNotifier.deliver_mimi_password_reset_instructions(self)  
  end

  def force_signup_flow?
    self.advertiser and self.advertiser.is_draft?
  end

  def display_name
    (self.first_name.blank? and self.last_name.blank?) ? "#{self.email}" : "#{self.first_name} #{self.last_name}"
  end
  
  def name_for_sort
    self.last_name || self.email
  end

  def display_role
    return self.roles.collect{|r| r.name }.join("<br />") if self.roles.any?
    return "N/A"
  end

  # def display_role
  #   if self.roles.length > 0
  #     return self.roles[0].name
  #   else
  #     return "N/A"
  #   end
  # end
  
  def display_group
   self.groups.each do |group|
      if group != Group.find_by_name("Default")
        if group != Group.find_by_name("Global")
          return group.name
        end
      end
    end
    return "N/A"
  end
  def view_list
    list = []
    if self.roles[0]
      racs = RoleActivityConcept.find(:all, :conditions=>["role_id =? and activity_id = ?", self.roles[0].id, Activity::VIEW.id])
      racs.each do |rac|
        list << rac.concept.name
      end  
    end
    return list
  end

  def is_tracking?(offer)
    self.tracked_offers.find_by_offer_id(offer)
  end
  
  def has_admin_role?
    self.roles.include? Role::ADMIN
  end

end
