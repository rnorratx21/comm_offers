class CreatePervasivePageId < ActiveRecord::Migration
  def self.up
    add_column :offers, :mobile_id, :integer
  end

  def self.down
    remove_column :offers, :mobile_id
  end
end
