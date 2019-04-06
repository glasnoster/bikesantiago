class Api::StationsController < ApplicationController
  def index
    @stations = if !search_params.empty?
      name_search = search_params[:name]
      Station.by_name(name_search)
    else
      Station.all
    end
  end

  private
  def search_params
    @search_params ||= params.permit(:name)
  end
end
