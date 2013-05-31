require File.dirname(__FILE__) + '/../spec_helper'

describe Search do
  describe "when searching with a location term" do
    it "should parse out zip code" do
      parsed_hash = SearchTermParser.parse("78701")
      parsed_hash[:zip_code].should == "78701"
      parsed_hash[:city].should be_nil
      parsed_hash[:state].should be_nil
    end

    it "should parse out city, state" do
      parsed_hash = SearchTermParser.parse("austin, tx")
      parsed_hash[:city].should == "austin"
      parsed_hash[:state].should == 'tx'
      parsed_hash[:zip_code].should be_nil
    end

    it "should parse city,state" do
      parsed_hash = SearchTermParser.parse("austin,tx")
      parsed_hash[:city].should == "austin"
      parsed_hash[:state].should == 'tx'
      parsed_hash[:zip_code].should be_nil
    end

    it "should convert austin to Austin, TX" do
      parsed_hash = SearchTermParser.parse("austin")
      parsed_hash[:city].should == "Austin"
      parsed_hash[:state].should == 'TX'
      parsed_hash[:zip_code].should be_nil
    end

    it "should convert san marcos to San Marcos, TX" do
      parsed_hash = SearchTermParser.parse(" san marcos ")
      parsed_hash[:city].should == "San Marcos"
      parsed_hash[:state].should == 'TX'
      parsed_hash[:zip_code].should be_nil
    end

    it "should convert non-quick city to neighborhood" do
      parsed_hash = SearchTermParser.parse("galleria")
      parsed_hash[:city].should be_nil
      parsed_hash[:state].should be_nil
      parsed_hash[:zip_code].should be_nil
      parsed_hash[:neighborhood].should == "galleria"
    end

  end

  describe "when searching a merchant name" do
    before(:each) do
      @hash = {}
    end
    
    it " should parse a merchant in city, st " do
      SearchTermParser.process_merchant_name(@hash, "Hula Hut in Austin, TX")
      @hash[:merchant].should == "Hula Hut"
    end
    it " should parse a merchant in zip " do
      SearchTermParser.process_merchant_name(@hash, "June's Buggy in 77700")
      @hash[:merchant].should == "June's Buggy"
    end
    it " should parse a merchant with 'In' in the name, and zip " do
      SearchTermParser.process_merchant_name(@hash, "In and Out Burger in 77700")
      @hash[:merchant].should == "In and Out Burger"
    end
    it " should parse a merchant with 'In' in the name and JUST city " do
      SearchTermParser.process_merchant_name(@hash, "West in East in Santa Barbara")
      @hash[:merchant].should == "West in East"
    end
    # end

    it "should include merchant name in the parsed hash " do
      parsed_hash = SearchTermParser.parse("frito pies in austin, tx")
      parsed_hash[:city].should == "austin"
      parsed_hash[:state].should == 'tx'
      parsed_hash[:zip_code].should be_nil
      parsed_hash[:merchant].should == 'frito pies'
    end
  end
  # describe "when searching with a category id" do    
  #   before do
  #     @page, @per_page = 1,1      
  #     @category_id = 10
  #     @search = Search.new :cat => @category_id
  #   end
  #   
  #   it "should search on category_id" do
  #     @search.should_receive(:search) do |proc|
  #       dsl = mock("dsl", :null_object => true)
  #       dsl.should_receive(:with).with(:category_id, @category_id)
  #       proc.call(dsl)
  #     end
  #     
  #     @offers = @search.offers(@page, @per_page) 
  #   end
  # end  
  
  # describe "when not searching with a category id" do
  #   before do
  #     @page, @per_page = 1,1      
  #     @search = Search.new 
  #   end
  # 
  #   it "should search on category_id" do
  #     @search.should_receive(:search) do |proc|
  #       dsl = mock("dsl", :null_object => true)
  #       dsl.should_not_receive(:with).with(:category_id, anything)
  #       proc.call(dsl)
  #     end
  # 
  #     @offers = @search.offers(@page, @per_page) 
  #   end
  # end
  
  # describe "when searching with a query" do
  #   before do
  #     @page, @per_page = 1,1      
  #     @query = "foo"
  #     @search = Search.new :q => @query
  #   end
  # 
  #   it "should search on category_id" do
  #     @search.should_receive(:search) do |proc|
  #       dsl = mock("dsl", :null_object => true)
  #       dsl.should_receive(:keywords).with(@query)
  #       proc.call(dsl)
  #     end
  # 
  #     @offers = @search.offers(@page, @per_page) 
  #   end
  # end
end
