class CreateDiscounts < ActiveRecord::Migration
  def self.up
    create_table :discounts do |t|
      t.string :promo_code
      t.decimal :amount_off
      t.integer :percent_off
      t.integer :months
      t.boolean :setup_display
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :discounts
  end
end
