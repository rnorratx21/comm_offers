class CreateInquiries < ActiveRecord::Migration
  def self.up
    create_table :inquiries do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :inquiry_type
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :inquiries
  end
end
