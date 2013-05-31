class SearchTermParser
  class << self
    ZIP_REG = /^[0-9]{5}$/
    CITY_STATE_REG = /^(.*),\s*([A-Za-z]*)$/
    NEIGHBORHOOD_REG = /^[a-zA-Z]+\s?[a-zA-Z]*\s?[a-zA-Z]*$/
    
    def parse(term)
      h = {}
      return h if term.blank?

      returned_term_minus_merchant = process_merchant_name(h, term)
      term = returned_term_minus_merchant if returned_term_minus_merchant

      if term =~ ZIP_REG
        h[:zip_code] = term
      elsif term =~ CITY_STATE_REG
        h[:city] = $1
        h[:state] = $2
      else parse_single_term(h, term)
      end
      h
    end
    
    def parse_single_term(hash,term)
      return if term.blank?
      unless assign_quick_city_name(hash,term)
        hash[:neighborhood] = term
      else
        hash[:state] = "TX"
      end
      hash
    end
  
    # THIS WILL NEED TO BE SMARTER VERY SOON :)
    # Also, this will NOT work outside of Texas (assumes TX)
    def assign_quick_city_name(hash,name)
      corrected_name = name.strip.titleize
      if[
      "Houston",
      "Katy",
      "Spring",
      "Austin",
      "Sugar Land",
      "Blanco",
      "Portland",
      "Brenham",
      "Conroe",
      "Meadows Place",
      "League City",
      "Pearland",
      "College Station",
      "Sugarland",
      "Bee Cave",
      "Round Rock",
      "Beecave",
      "San Marcos",
      "San Antonio"].include? corrected_name
        hash[:city] = corrected_name
      else
        return false
      end
      true
    end
    
    def process_merchant_name(hash,term)
      return if term.blank?
      if term =~ /(.*)( in )(.*)/
puts "matchers: 1: #{$1} 3: #{$3}"
        hash[:merchant] = $1
        return $3
      end 
    end
  end
end