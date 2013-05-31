require 'oauth'
require 'garb'

class GaProfile
  TOKEN = '1/5zVFCJB5uWlSH5PQnmAknn3REOScB0lr-yB-F5UzRdM'
  SECRET = 'HaqR7QelQuU7g4v8BGIRB1Er'

  attr_reader :profile

  def initialize
    # setup per https://github.com/vigetlabs/garb/wiki/oauth-session
    # authorized by nick@communityoffers.com
    consumer = OAuth::Consumer.new('anonymous', 'anonymous', {
      :site => 'https://www.google.com',
      :request_token_path => '/accounts/OAuthGetRequestToken',
      :access_token_path => '/accounts/OAuthGetAccessToken',
      :authorize_path => '/accounts/OAuthAuthorizeToken'
    })
    access_token = OAuth::AccessToken.new(consumer, TOKEN, SECRET)
    Garb::Session.access_token = access_token

    @profile = Garb::Management::Profile.all.detect {|p| p.web_property_id == 'UA-13251849-1'}    
  end
  
  
end