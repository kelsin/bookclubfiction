class SearchController < ApplicationController
  respond_to :json

  def search
    authorize! :search, self

    @response = client.search_books(params[:q], :page => params[:page])

    respond_with @response
  end
end
