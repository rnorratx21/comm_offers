class Search
  include Validatable

  attr_accessor :query
  attr_accessor :zip_code
  attr_accessor :city
  attr_accessor :state
  attr_accessor :category_id
  attr_accessor :proximity
  attr_accessor :within
  attr_accessor :neighborhood
  attr_accessor :search_text
  attr_accessor :is_personalized

  DEFAULT_PROXIMITY_IN_MILES = 10

  def initialize(params={}, current_location=nil)
    @proximity = 10
    @current_location = current_location

    @query = params[:q]

    @origin = params[:origin]
    
    @search_text = params[:search_text]
    @category_id = params[:cat]
    @search_randomizer = params[:search_randomizer]

    if params[:zip_code_ids] # is a personalized search
      @zip_code_ids = params[:zip_code_ids]
    else
      parsed_entry = SearchTermParser.parse(params[:search_text])
      return unless parsed_entry
      @city = parsed_entry[:city] if parsed_entry[:city]
      @state = parsed_entry[:state] if parsed_entry[:state]
      @zip_code = parsed_entry[:zip_code] if parsed_entry[:zip_code]
      @neighborhood = parsed_entry[:neighborhood] if parsed_entry[:neighborhood]
      @merchant_name = parsed_entry[:merchant] if parsed_entry[:merchant]
    end

    @category_ids = params[:category_ids]
# raise "@zip_code_id #{@zip_code_ids}, @category_ids #{@category_ids}"
    @proximity = params[:proximity]
    @within = params[:within]
  end

  def origin
    @origin ||= zip_code_origin || @current_location
  end

  def search_origin
    @search_origin ||= zip_code_origin || city_st_origin || neighborhood_origin || default_origin
  end
  
  def zip_code_origin
    @zip_code if @zip_code
  end
  
  def city_st_origin
    @city+", "+@state if @city and @state
  end
  
  def neighborhood_origin
    if @neighborhood
      neighborhood = Neighborhood.find_by_name(@neighborhood)
      return neighborhood.location if not neighborhood.nil?
    end
  end
  
  def default_origin
    return @origin.location if @origin
    return @current_location.location if @current_location
  end

  def zip_codes(o, proximity)
    ZipCode.find(:all, :origin => o, :within => proximity, :order => 'distance asc')
  end
  
  def explicit_zip_codes
    ZipCode.all(:conditions => {:id => @zip_code_ids})
  end

  # Priority of search resulots:
  #   1) Diamond for zip code
  #   2) platinum for zip code
  #   3) gold for zip code
  #   4) diamond
  #   5) platinum
  #   6) gold
  #   7) randomize
  def offers(page, per_page)
    zips = @zip_code_ids ? explicit_zip_codes : zip_codes(search_origin, proximity_for_search)
    codes = zips.collect {|zip| zip.zip_code }
    codes.move_by_name(@zip_code, 0)

    zip_named_scope = ZipCode.with_offers.all(:conditions => {:zip_code => codes})

    named_scope = Offer.active.in_zip_codes(codes, zip_named_scope, @search_randomizer)
    if @merchant_name
      ns_result = named_scope.by_business_name_keyword(@merchant_name)
      if ns_result.size > 0
        @got_merchant_match = true
        named_scope = ns_result
      end
    end
    tmp_cat = named_scope
    named_scope = named_scope.by_zip_codes(codes) if codes.length > 0# or service_area_codes.length > 0
    cat_filter = @category_ids || @category_id
    named_scope = named_scope.with_category(cat_filter) if cat_filter

    # Adjust search results based on priority
    diamond_in_zip = offers_in_zip(named_scope, ContractPlan::DIAMOND)
    platinum_in_zip = offers_in_zip(named_scope, ContractPlan::PLATINUM)
    gold_in_zip = offers_in_zip(named_scope, ContractPlan::GOLD)
    # platinum_in_zip = named_scope.select {|offer| offer.contract_plan == ContractPlan::PLATINUM and offer.address.zip_code == @zip_code}
    # offer_in_zip = named_scope.select {|offer| offer.address.zip_code == @zip_code}
    
    named_scope = diamond_in_zip | platinum_in_zip | gold_in_zip | named_scope #offer_in_zip.shuffle | named_scope.shuffle

    offers = named_scope.paginate(:page => page, :per_page => per_page)

    #category_facets = Offer.active.in_zip_codes(codes, zip_named_scope).facets.collect { |c| CategoryFacet.new(c.category, 2) }
    facet_data = Hash.new(0)
    tmp_cat.each do |offer|
      facet_data[offer.category_id] += 1
    end
    category_facets = []
    facet_data.each do |k,v|
      category = Category.find(k)
      category_facets << CategoryFacet.new(category, v)
    end
    
    # directories = DirectoryListing.by_zip_codes(codes)
    
    search_results = SearchResults.new(offers, category_facets, origin, [])

    add_affiliate_offers(search_results, page, per_page) unless @got_merchant_match or @is_personalized
  
    search_results
  end
  
  private
  
  def offers_in_zip(named_scope, plan)
    named_scope.select {|offer| offer.contract and offer.contract_plan == plan and offer.address.zip_code == @zip_code}
  end
  
  def add_affiliate_offers(search_results, page, per_page)
    num_affiliate_offers = compute_num_affiliate_offers(search_results.offers.length, page, per_page)
    search_results.add_offers(AffiliateOffer.rand(num_affiliate_offers))
    search_results
  end

  def compute_num_affiliate_offers(num_results, page, per_page)
    return 1 if page.to_i > 1

    num_missing = per_page - num_results
    max_affiliate_offers = 5

    [ num_missing, max_affiliate_offers ].min
  end

  def proximity_for_search
    if @proximity.blank?
      DEFAULT_PROXIMITY_IN_MILES
    else
      @proximity.to_i
    end
  end
  
end

