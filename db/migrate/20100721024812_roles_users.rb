class RolesUsers < ActiveRecord::Migration
  def self.up
      create_table :roles_users, :id => false do |t|
        t.references :user
        t.references :role
        t.timestamps
      end


  def self.down
    drop_table :roles_users
  end
  end
end