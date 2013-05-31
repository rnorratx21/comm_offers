class CategoryFacet
  attr_reader :category, :count
  
  def initialize(category, count)
    @category, @count = category, count
  end
end