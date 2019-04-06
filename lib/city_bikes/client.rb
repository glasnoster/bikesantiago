require 'httparty'

module CityBikes
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
      response = HTTParty.get(network_url, follow_redirects: true, query: query || {})
      parse_response(response)
    end

    def parse_response(response)
      case response.code
      when 200..299
        JSON.parse(response.body) if response.body
      when 400..499
        raise ApiError.new("#{response.code} when trying to connect to #{network_url}")
      when 500..599
        raise ApiError.new("#{response.code} when trying to connect to #{network_url}")
      end
    end
  end
end
