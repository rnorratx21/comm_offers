class CreateRoleActivityConcepts < ActiveRecord::Migration
  def self.up
    create_table :role_activity_concepts do |t|
      t.references :role
      t.references :activity
      t.references :concept
      t.timestamps
    end
  end

  def self.down
    drop_table :role_activity_concepts
  end
end