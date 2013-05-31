class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id
      t.boolean :is_male
      t.integer :home_zip_code_id
      t.boolean :do_email_offer_updates

      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
