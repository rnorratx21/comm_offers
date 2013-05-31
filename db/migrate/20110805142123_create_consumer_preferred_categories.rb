class CreateConsumerPreferredCategories < ActiveRecord::Migration
  def self.up
    create_table :consumer_preferred_categories do |t|
      t.integer :profile_id
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :consumer_preferred_categories
  end
end
