class Api::StationsController < ApplicationController
  def index
    @stations = search_params.empty? ? all_stations : search_stations
  end

  private
  def search_params
    @search_params ||= params.permit(:name, :comuna)
  end

  def all_stations
    Station.all
  end

  def search_stations
    if search_params[:name]
      Station.by_name(search_params[:name])
    elsif search_params[:comuna]
      Station.joins(:comuna)
        .where(comuna: Comuna.by_name(search_params[:comuna]))
        .includes(:comuna)
    end
  end
end
