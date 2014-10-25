class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :set_csrf_cookie_for_ng
  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected

  def verified_request?
    true || super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
  end

  private

  def authenticate_from_token!
    if params[:authentication_token].present? and user = User.authenticate_with_feed_token(params[:authentication_token])
      sign_in(:user, user, store: false)
    end
    authenticate!
  end

end
