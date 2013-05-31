require 'fastercsv'

class CSVBuilder
  def self.build_from_arrays(arrays)
    FasterCSV.generate do |csv|
      arrays.each do |array|
        csv << array
      end
    end
  end
  
  def initialize(collection)
    if collection.any?
      @collection = collection
      @sampler = collection.first
      @excludes = sampler.csv_excludes rescue []
    end
  end
  
  def exclude_list
    list = ["crypted_password", "password_salt"]
  end

  def build
    self.class.build_from_arrays(@rows || build_arrays)
    # FasterCSV.generate do |csv|
    #   csv << @keys
    #     csv << row
    #   end
    # end
  end
  
  def build_arrays    
    @keys = @sampler.attribute_names.reject{|x| @excludes.include?(x) or exclude_list.include?(x) }
    shift_names
    @rows = Array.new([@keys])
    @collection.each do |obj|
      row = [] and @keys.each{|k| row << obj.send(k).to_s }
      @rows << row
    end
    @rows
  end

  def shift_names
    # put id first for readability
    @keys.unshift(@keys.delete(@keys.grep(/^id/i).first))
  end
  

end