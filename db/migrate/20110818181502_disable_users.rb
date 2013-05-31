class DisableUsers < ActiveRecord::Migration
  def self.up
    User.reset_column_information
    %w(mirven@calcedon.com mstephan@calcedon.com ryan@mysmallidea.com).each do |email|
      User.find_by_email(email).update_attributes(:is_disabled => true)
    end
  end

  def self.down
  end
end
