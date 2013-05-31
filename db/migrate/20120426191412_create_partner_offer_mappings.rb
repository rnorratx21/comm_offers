class CreatePartnerOfferMappings < ActiveRecord::Migration
  def self.up
    create_table :partner_offer_mappings do |t|
      t.integer :partner_id
      t.integer :offer_id
      t.string :partner_id_value

      t.timestamps
    end
  end

  def self.down
    drop_table :partner_offer_mappings
  end
end
