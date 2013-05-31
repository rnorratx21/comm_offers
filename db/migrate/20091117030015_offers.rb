class Offers < ActiveRecord::Migration
  def self.up
    create_table :offers do |t|
      t.integer :advertiser_id
      t.integer :category_id
      t.integer :address_id
			t.integer :exclusive_zip_code_id
      t.string :headline
      t.string :title
      t.text :description
      t.string :hours
      t.string :effective
      t.date :expires_on
			t.string :payment_methods
			t.boolean :mobile, :null => false, :default => false
			t.string :state
			t.string :sms_marketing_info
      t.timestamps
    end
  end

  def self.down
    drop_table :offers
  end
end
