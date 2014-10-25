require 'google/api_client'

class AuthController < ApplicationController
  def add_google_account
    client = Google::APIClient.new(
        :application_name => 'Example Ruby application',
        :application_version => '1.0.0'
    )

    # # client.authorization.client_id = ENV["GOOGLE_CLIENT_ID"]
    # # client.authorization.client_secret = ENV["GOOGLE_CLIENT_SECRET"]
    # # client.authorization.scope = %w(https://www.googleapis.com/auth/calendar email profile)

    calendar = client.discovered_api('calendar', 'v3')

    # client_api = Signet::OAuth2::Client.new(
    #   :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
    #   :audience => 'https://accounts.google.com/o/oauth2/token',
    #   :scope => 'https://www.googleapis.com/auth/calendar',
    #   :client_id => ENV["GOOGLE_CLIENT_ID"],
    #   :client_secret => ENV["GOOGLE_CLIENT_SECRET"],
    #   :grant_type => 'client_credentials',
    #   :access_type => 'offline')
    # client_api.grant_type = 'client_credentials'
    # #client_api.code = 
    # a = client_api.generate_access_token_request
    # client_api.fetch_access_token!
    # # result = client.execute(:api_method => calendar.events.list,
    # #                             :parameters => {'calendarId' => 'primary'},
    # #                             :authorization => client_api)

    key = Google::APIClient::KeyUtils.load_from_pkcs12(Rails.root.join('config','key.p12'),'notasecret')
    client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => %w(https://www.googleapis.com/auth/calendar email profile),
      :issuer => '36246022485-eoqhphlvqg627lo56t3or4r9m6hhu6gi@developer.gserviceaccount.com',
      :signing_key => key)
    client.authorization.fetch_access_token!

    result = client.execute(:api_method => calendar.events.list,
                                :parameters => {'calendarId' => 'primary'},
                                :authorization => client.authorization)
  
    render json: [auth_hash,result.data]
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
