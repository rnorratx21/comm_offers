class CreatePervasiveCouponId < ActiveRecord::Migration
  def self.up
    add_column :advertisers, :mobile_id, :string
  end

  def self.down
    remove_column :advertisers, :mobile_id, :string
  end
end
