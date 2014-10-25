Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"],
           {
               scope: (ENV["OAUTH_SCOPE"] and ENV["OAUTH_SCOPE"].split(' '))
           }
end
