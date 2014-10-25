require 'google/api_client'

class AuthController < ApplicationController
  def add_google_account
    client = Google::APIClient.new(
        :application_name => 'Example Ruby application',
        :application_version => '1.0.0'
    )

    client.authorization.client_id = ENV["GOOGLE_CLIENT_ID"]
    client.authorization.client_secret = ENV["GOOGLE_CLIENT_SECRET"]
    client.authorization.scope = %w(https://www.googleapis.com/auth/calendar email profile)

    calendar = client.discovered_api('calendar', 'v3')

    result = client.execute(:api_method => calendar.events.list,
                                :parameters => {'calendarId' => 'primary'},
                                :authorization => {code: auth_hash.credentials.token})

    render json: [auth_hash, result.data]
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
