class AddDobToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :dob, :date
  end

  def self.down
    remove_column :profiles, :dob
  end
end
