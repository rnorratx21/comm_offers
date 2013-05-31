class Categories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name
      t.boolean :platinum
      t.integer :category_type_id
      t.timestamps
    end
    
    create_table :category_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :categories
    drop_table :category_types
  end
end
