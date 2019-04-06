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
    Station.create(
      name: station_hash["name"],
      citybikes_id: station_hash["id"])
  end

end
