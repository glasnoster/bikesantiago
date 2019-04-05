require 'httparty'

module CityBike
  class NotFoundError < StandardError; end
  class ApiError < StandardError; end

  class Client
    attr_reader :base_url, :network

    def initialize(base_url, network)
      raise ArgumentError.new("base_url cannot be blank") if base_url.blank?
      raise ArgumentError.new("network cannot be blank") if network.blank?

      @base_url = base_url
      @network = network
    end

    def list_stations
      result = get(network_url)
      result["network"]["stations"]
    end

    private
    def network_url
      @network_url ||= "#{@base_url}/networks/#{network}"
    end

    def get(entity, query=nil)
      response = HTTParty.get(network_url, query: query || {})
      parse_response(response)
    end

    def parse_response(response)
      case response.code
      when 200
        JSON.parse(response.body)
      when 404
        raise NotFoundError
      else
        raise ApiError
      end
    end
  end
end
