class RenameMobileIdOnAdvertisersToOldPervasivePageId < ActiveRecord::Migration
  def self.up
    rename_column :advertisers, :mobile_id, :old_pervasive_page_id
  end

  def self.down
  end
end
