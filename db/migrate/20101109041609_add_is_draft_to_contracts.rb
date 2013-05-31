class AddIsDraftToContracts < ActiveRecord::Migration
  def self.up
    add_column :contracts, :is_draft, :boolean, :default => false
  end

  def self.down
    remove_column :contracts, :is_draft
  end
end
