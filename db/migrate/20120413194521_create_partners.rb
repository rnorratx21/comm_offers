class CreatePartners < ActiveRecord::Migration
  def self.up
    create_table :partners do |t|
      t.string :name
      t.string :username
      t.string :password
      t.string :token

      t.timestamps
    end
  end

  def self.down
    drop_table :partners
  end
end
