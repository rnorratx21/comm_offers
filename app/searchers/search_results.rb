class SearchResults
  attr_reader :offers, :category_facets, :origin, :directories

  def initialize(offers, category_facets, origin, directories)    
    @offers, @category_facets, @origin, @directories = offers, category_facets, origin, directories
  end
  
  def add_offers(offers)
    @offers.concat(offers)
		@offers.paginate
  end

	def categories_by_name
		@category_facets.sort do |f1, f2|
			f1.category.name <=> f2.category.name
		end
	end  
  
  def length
    offers.total_entries
  end
  
  def mappable?
    @offers.any? { |o| o.mappable? }
  end
end