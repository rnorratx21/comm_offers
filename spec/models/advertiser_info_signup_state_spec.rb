require File.dirname(__FILE__) + '/../spec_helper'

# describe AdvertiserInfoSignupState do
  # before do
  #   @state = AdvertiserInfoSignupState.new(nil, :next => :next, :previous => :previous)
  # end
  # 
  # it "should be invalid" do
  #   @state.should_not be_valid
  # end
  # 
  # it "should return it's name" do
  #   @state.state_name.should == :advertiser_info
  # end
  # 
  # it "should return the next state's name" do
  #   @state.next_state_name.should == :next
  # end
  # 
  # describe "updating the state" do
  #   before do
  #     @valid_params = {
  #       :advertiser_name => "Foo",
  #       :address => {
  #         :street => "1221 Congress Ave",
  #         :city => "Austin",
  #         :state => "TX",
  #         :zip_code => "78704",
  #         :phone_number => "512-555-1212"
  #       }
  #     }
  #   end
  #   
  #   it "should be valid with valid params" do
  #     @state.update_attributes(@valid_params)
  #     @state.should be_valid
  #   end
  #   
  #   it "should not be valid with missing advertiser name" do
  #     @state.update_attributes(@valid_params.except(:advertiser_name))
  #     @state.should_not be_valid
  #   end
  # end
# end