class AssignNamesAndRolesForSalespeople < ActiveRecord::Migration
  def self.up
    ben = User.find_by_email("bcarolan@communityoffers.com")
    ben.update_attributes(:first_name => "Benjamin", :last_name => "Carolan")
    ben.roles << Role::SALES
    phil = User.find_by_email("palva@communityoffers.com")
    phil.update_attributes(:first_name => "Philip", :last_name => "Alva")
    phil.roles << Role::SALES
    maria = User.find_by_email("misbell@communityoffers.com")
    maria.roles << Role::SALES
    
    active_users = [%w(ppayne@communityoffers.com Phillip Payne),
      %w(gmartin@communityoffers.com Gen Martin),
    %w(aperlin@communityoffers.com Andrew Perlin),
    %w(gnavarro@communityoffers.com Gerald Navarro),
    %w(jkolin@communityoffers.com Janice Kolin),
    %w(sedwards@communityoffers.com Shelly Edwards)]
    active_users.each do |user_array|
      add_user(user_array)
    end
  end

  def self.down
  end

  def self.add_user(user_array)
    user = User.find_by_email(user_array[0])
    user ||= User.create(:email => user_array[0], :first_name => user_array[1], :last_name => user_array[2],
      :password => 'password', :password_confirmation => 'password', :is_disabled => true)
    user.roles << Role::SALES
  end
end
