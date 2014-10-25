require 'google/api_client'

class AuthController < ApplicationController
  def add_google_account
    ow = OauthWrapper.new

    ow.authorization.code = auth_hash.credentials.token
    ow.authorization.grant_type = 'authorization_code'
    binding.pry


  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
