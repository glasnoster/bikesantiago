require 'httparty'

module MeteoChile
  class ApiError < StandardError; end

  class Client
    attr_reader :base_url

    def initialize(base_url)
      raise ArgumentError.new("base_url cannot be blank") if base_url.blank?

      @base_url = base_url
    end

    def list_comunas
      result = get(base_url)

      result["features"]
    end

    private
    def get(entity, query=nil)
      response = HTTParty.get(base_url, follow_redirects: true, query: query || {})
      parse_response(response)
    end

    def parse_response(response)
      case response.code
      when 200..299
        JSON.parse(response.body) if response.body
      when 400..499
        raise ApiError.new("#{response.code} when trying to connect to #{base_url}")
      when 500..599
        raise ApiError.new("#{response.code} when trying to connect to #{base_url}")
      end
    end

  end
end
