require 'google/api_client'

class OauthWrapper
  def initialize
    @@client = Google::APIClient.new(
      :application_name => 'Meetly',
      :application_version => '1.0.0'
    )
    key = Google::APIClient::KeyUtils.load_from_pkcs12(Rails.root.join('config','key.p12'),'notasecret')
    @@client.authorization = Signet::OAuth2::Client.new(
      token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
      audience: 'https://accounts.google.com/o/oauth2/token',
      scope: ENV['OAUTH_SCOPE'],
      issuer: ENV['GOOGLE_ISSUER'],
      client_id: ENV['GOOGLE_CLIENT_ID'],
      client_secret: ENV['GOOGLE_CLIENT_SECRET']
      )
    @@client
  end

  def client
    @@client
  end

  def authorization
    
    @@client.authorization
  end

  def update_authorization(user)
    @@client.authorization.access_token = user.access_token
    @@client.authorization.refresh_token = user.refresh_token
    @@client.authorization.expires_in = user.expires_in
    @@client.authorization.issued_at = user.issued_at
  end

  def execute(opts={})
    @@client.execute(opts.merge(authorization: @@client.authorization))
  end

  def attributes_hash
    {
      access_token: @@client.authorization.access_token,
      refresh_token: @@client.authorization.refresh_token,
      expires_in: @@client.authorization.expires_in,
      issued_at: @@client.authorization.issued_at
    }
  end

end