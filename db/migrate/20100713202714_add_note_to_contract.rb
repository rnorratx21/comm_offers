class AddNoteToContract < ActiveRecord::Migration
  def self.up
    add_column :contracts, :notes, :text
  end

  def self.down
    remove_column :contracts, :notes
  end
end
