class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :goodreads_client

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def goodreads_client
    if session[:oauth_access_token] and session[:oauth_access_token_secret]
      access_token = OAuth::AccessToken.new(OAuth::Consumer.new(Goodreads.configuration[:api_key],
                                                                Goodreads.configuration[:api_secret],
                                                                :site => 'http://www.goodreads.com'),
                                            session[:oauth_access_token],
                                            session[:oauth_access_token_secret])
      Goodreads.new :oauth_token => access_token
    else
      Goodreads.new
    end
  end
end
