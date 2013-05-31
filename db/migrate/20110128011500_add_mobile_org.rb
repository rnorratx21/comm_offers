class AddMobileOrg < ActiveRecord::Migration
  def self.up
    add_column :advertisers, :mobile_org_id, :integer
  end

  def self.down
    remove_column :advertisers, :mobile_org_id
  end
end
