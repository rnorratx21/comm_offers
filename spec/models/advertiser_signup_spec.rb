require File.dirname(__FILE__) + '/../spec_helper'

# describe AdvertiserSignup do
#   before do
#     @advertiser_signup = AdvertiserSignup.new
#   end
#   
#   describe "updating a state" do
#     before do
#       @controller = Advertiser::SignupController.stub_instance(:redirect_to_state => nil, :render_state => nil)
# 
#       @advertiser_info_signup_state_params = {
#         :advertiser_name => "foo",
#         :address => {
#           :street => "1221 Congress Ave",
#           :city => "Austin",
#           :state => "TX",
#           :zip_code => "78704",
#           :phone_number => "512-555-1212"            
#         }
#       }      
#     end
#     
#     describe "updating with valid params" do
#       it "should redirect to the next state" do
#         @advertiser_signup.current_state_name = :advertiser_info
#         @advertiser_signup.update(@controller, { :advertiser_info_signup_state => @advertiser_info_signup_state_params })
#         @controller.should have_received(:redirect_to_state).with(:category)
#       end
#     end
#     
#     describe "updating with invalid params" do
#       it "should render the current state" do
#         # @controller.should_receive(:render_state).with(:advertiser_info)
#         @advertiser_signup.current_state_name = :advertiser_info
#         @advertiser_signup.update(@controller, { :advertiser_info_signup_state => @advertiser_info_signup_state_params.except(:advertiser_name) })
#         @controller.should have_received(:render_state).with(:advertiser_info)
#       end
#     end
#   end
# end
