class CreateConsumerPreferredZipCodes < ActiveRecord::Migration
  def self.up
    create_table :consumer_preferred_zip_codes do |t|
      t.integer :profile_id
      t.integer :zip_code_id

      t.timestamps
    end
  end

  def self.down
    drop_table :consumer_preferred_zip_codes
  end
end
