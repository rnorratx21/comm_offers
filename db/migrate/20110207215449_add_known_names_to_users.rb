class AddKnownNamesToUsers < ActiveRecord::Migration
  def self.up
    User.update_name_by_email "misbell@communityoffers.com", "Maria", "Isbell"
    User.update_name_by_email "dcarolan@communityoffers.com", "David", "Carolan"
    User.update_name_by_email "mirven@calcedon.com", "Marcus", "Irvin"
    User.update_name_by_email "mstephan@calcedon.com", "Mark", "Stephan"
  end

  def self.down
  end
end
