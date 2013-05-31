class AddFileToContract < ActiveRecord::Migration
  def self.up
    add_column :contracts, :file, :string
    add_column :contracts, :content_type, :string
  end

  def self.down
    remove_column :contracts, :content_type
    remove_column :contracts, :file
  end
end
