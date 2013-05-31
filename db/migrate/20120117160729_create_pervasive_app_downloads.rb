class CreatePervasiveAppDownloads < ActiveRecord::Migration
  def self.up
    create_table :pervasive_app_downloads do |t|
      t.string :email
      t.string :ip
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pervasive_app_downloads
  end
end
