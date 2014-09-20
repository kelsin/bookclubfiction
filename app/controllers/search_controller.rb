class SearchController < ApplicationController
  respond_to :json

  def search
    @response = client.search_books(params[:q], :page => params[:page])

    respond_with @response
  end
end
