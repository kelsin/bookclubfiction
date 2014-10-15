class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied, :with => :unauthorized
  rescue_from MongoMapper::DocumentNotFound, :with => :not_found

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :goodreads_client

  skip_before_action :verify_authenticity_token
  check_authorization :unless => :devise_controller?

  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end

  def client
    Goodreads.new Goodreads.configuration
  end

  private

  def unauthorized(error)
    render :json => {:error => error.message}, :status => :unauthorized
  end

  def not_found
    render :json => {:error => 'Not Found'}, :status => :not_found
  end
end
