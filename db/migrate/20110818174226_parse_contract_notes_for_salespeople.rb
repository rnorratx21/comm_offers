class ParseContractNotesForSalespeople < ActiveRecord::Migration
  def self.up
    Contract.all(:conditions => ['notes IS NOT NULL']).each do |c| 
      notes = c.notes
      next if notes.blank?
      if notes.match(/^Philip Alva/) or 
           notes.match(/^Phillip Alva/) or 
           notes.match(/^Phil Alva/)
        user = User.find_by_email "palva@communityoffers.com"
      elsif notes.match(/^Benjamin Carolan/) or 
            notes.match(/^Ben Carolan/)
        user = User.find_by_email "bcarolan@communityoffers.com"
      elsif notes.match(/^Maria Isbell/)
        user = User.find_by_email "misbell@communityoffers.com"
      elsif notes.match(/^Phillip Payne/)
        user = User.find_by_email "ppayne@communityoffers.com"
      elsif notes.match(/^Gen Martin/)
        user = User.find_by_email "gmartin@communityoffers.com"
      elsif notes.match(/^Janice Kolin/) 
        user = User.find_by_email "jkolin@communityoffers.com"
      elsif notes.match(/^Shelly Edwards/)  
        user = User.find_by_email "sedwards@communityoffers.com"
      elsif notes.match(/^Andrew Perlin/)  
        user = User.find_by_email "aperlin@communityoffers.com"
      elsif notes.match(/^Gerald Navarro/)  
        user = User.find_by_email "gnavarro@communityoffers.com"
      else
        next
      end
      c.update_attributes(:salesperson => user) if user
    end
  end

  def self.down
  end
end
