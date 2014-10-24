class AuthController < ApplicationController
  def add_google_account
    render json: auth_hash
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
