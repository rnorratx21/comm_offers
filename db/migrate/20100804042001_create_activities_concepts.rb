class CreateActivitiesConcepts < ActiveRecord::Migration
  def self.up
    create_table :activities_concepts , :id => false do |t|
      t.references :concept
      t.references :activity
      t.timestamps
    end
  end

  def self.down
    drop_table :activities_concepts
  end
end