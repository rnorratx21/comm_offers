
# module Enumerable
#   def dups
#     inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
#   end
# end
# 
class ZipCodeBlock
  include Validatable

  NUM_ZIP_CODES = 10  
  ATTRIBUTES = (1..NUM_ZIP_CODES).map { |i| :"zip_code#{i}" }
  
  ATTRIBUTES.each do |attribute|
    attr_accessor attribute
  end
  
  def zip_codes
    zip_codes = ATTRIBUTES.map { |a| send(a) }
    zip_codes.reject { |z| z.blank? }
  end
  
  def initialize(params=nil)
    update(params)
  end
  
  def update(params)
    params.each { |key,value| instance_variable_set "@#{key}", value } if params
  end
  
  # def clear!
  #   (1..NUM_ZIP_CODES).each do |i|
  #     send("zip_code#{i}=", "")
  #   end
  # end
  # 
  # def zip_codes=(zip_codes)
  #   clear!    
  #   zip_codes.each_with_index do |zip_code, i|
  #     send("zip_code#{i+1}=", zip_code)
  #   end
  # end
  # 
  # def compact!
  #   compacted_zip_codes = zip_codes
  #   self.zip_codes = compacted_zip_codes
  # end
  # 
  # def remove_duplicates!(previous_zip_codes)
  #   all_zipcodes = zip_codes + previous_zip_codes    
  #   self.zip_codes = (zip_codes - previous_zip_codes).uniq    
  #   all_zipcodes.dups
  # end
  #   
  ATTRIBUTES.each do |attribute|
    validates_true_for attribute, :logic => lambda { validate_zip_code(attribute) }
  end
  
  def validate_zip_code(attribute)
    zip_code = send(attribute)
    
    if not zip_code.blank?
      if not (zip_code =~ /^\d{5}$/)
        errors.add(attribute, ErrorMessages::ZIP_CODE)
      elsif not ZipCode.exists?(:zip_code => zip_code)
        errors.add(attribute, ErrorMessages::ZIP_CODE_NOT_IN_DB)
      end
    end
    true
  end
  
end
