class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def goodreads
    auth = request.env['omniauth.auth']
    @user = User.find_for_goodreads(auth)

    sign_in_and_redirect @user, :event => :authentication
    set_flash_message(:notice, :success, :kind => "Goodreads") if is_navigational_format?
  end
end
