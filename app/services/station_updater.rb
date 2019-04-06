class StationUpdater
  attr_reader :client

  def self.call
    base_url = Rails.configuration.x.city_bikes.base_url
    network = Rails.configuration.x.city_bikes.network
    api_client = CityBikes::Client.new(base_url, network)

    updater = StationUpdater.new(api_client)
    updater.update_stations!
  end

  def initialize(client)
    @client = client
  end

  def update_stations!
    begin
      stations = client.list_stations
      stations.each do |station_hash|
        create_or_update_station(station_hash)
      end
    rescue CityBikes::ApiError => e
      Rails.logger.error(e.message)
    end
  end

  private
  def create_or_update_station(station_hash)
    station = Station.find_by_citybikes_id(station_hash["id"]) || create_station(station_hash)
  end

  def create_station(station_hash)
    lon = station_hash["longitude"]
    lat = station_hash["latitude"]

    comuna = Comuna.containing_point(longitude: lon, latitude: lat).first
    station = Station.create(
      citybikes_id: station_hash["id"],
      name:         format_name(station_hash["name"]),
      location:     format_location(lon, lat),
      comuna:       comuna)
  end

  def format_name(name)
    name.split(' - ')[1]
  end

  def format_location(lng, lat)
    "POINT(#{lng} #{lat})"
  end

end
