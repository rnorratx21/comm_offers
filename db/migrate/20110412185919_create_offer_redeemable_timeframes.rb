class CreateOfferRedeemableTimeframes < ActiveRecord::Migration
  def self.up
    create_table :offer_redeemable_timeframes do |t|
      t.integer :offer_id
      t.string :day
      t.integer :start_minute
      t.integer :end_minute

      t.timestamps
    end
  end

  def self.down
    drop_table :offer_redeemable_timeframes
  end
end
