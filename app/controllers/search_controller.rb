class SearchController < ApplicationController
  respond_to :json

  def search
    @response = client.search_books(params[:q])

    respond_with @response
  end
end
