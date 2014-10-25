require 'google/api_client'

class AuthController < ApplicationController
  def add_google_account
    client = Google::APIClient.new(
        :application_name => 'Example Ruby application',
        :application_version => '1.0.0'
    )

    calendar = client.discovered_api('calendar', 'v3')

    key = Google::APIClient::KeyUtils.load_from_pkcs12(Rails.root.join('config','key.p12'),'notasecret')
    client.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience => 'https://accounts.google.com/o/oauth2/token',
      :scope => %w(https://www.googleapis.com/auth/calendar email profile),
      :issuer => '36246022485-eoqhphlvqg627lo56t3or4r9m6hhu6gi@developer.gserviceaccount.com',
      :signing_key => key)
    client.authorization.code = auth_hash.credentials.token
    client.authorization.fetch_access_token!
    current_user.access_token = client.authorization.access_token
    current_user.save!
    render json:GoogleCalendar.first.events(Time.now - 20.days,Time.now)
    # redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
