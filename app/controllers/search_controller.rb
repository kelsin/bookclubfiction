class SearchController < ApplicationController
  before_action :authenticate_user!

  respond_to :json

  def search
    @response = client.search_books(params[:q], :page => params[:page])

    respond_with @response
  end
end
