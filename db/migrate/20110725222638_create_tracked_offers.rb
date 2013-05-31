class CreateTrackedOffers < ActiveRecord::Migration
  def self.up
    create_table :tracked_offers do |t|
      t.integer :user_id
      t.integer :offer_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tracked_offers
  end
end
