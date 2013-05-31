class AddIsDraftToAdvertiser < ActiveRecord::Migration
  def self.up
    add_column :advertisers, :is_draft, :boolean, :default => false
  end

  def self.down
    remove_column :advertisers, :is_draft
  end
end
