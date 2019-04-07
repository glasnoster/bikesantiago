module StationSearchable
  def set_stations
    @stations = station_search_params.empty? ? all_stations : search_stations
  end

  private
  def station_search_params
    @station_search_params ||= params.permit(:name, :comuna)
  end

  def all_stations
    Station.all
  end

  def search_stations
    if station_search_params[:name]
      Station.by_name(station_search_params[:name])
    elsif station_search_params[:comuna]
      Station.joins(:comuna)
        .where(comuna: Comuna.by_name(station_search_params[:comuna]))
        .includes(:comuna)
    end
  end
end
