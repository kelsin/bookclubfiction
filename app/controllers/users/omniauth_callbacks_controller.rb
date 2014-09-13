class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def goodreads
    @user = User.find_for_goodreads(request.env['omniauth.auth'])

    session[:oauth_access_token] = request.env['omniauth.auth']['credentials']['token']
    session[:oauth_access_token_secret] = request.env['omniauth.auth']['credentials']['secret']

    sign_in_and_redirect @user, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Goodreads") if is_navigational_format?
  end
end
