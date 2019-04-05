require 'city_bike/client'
require 'webmock/rspec'

describe CityBike::Client do
  let(:base_url) { "http://api.citybik.es/v2" }
  let(:network)  { "bikesantiago" }
  let(:client) { CityBike::Client.new(base_url, network) }

  let(:mock_result) do
    '''
    {
      "network": {
        "stations": [
          {
          "empty_slots": 9,
          "extra": {
            "address": "V35 - Municipalidad de Vitacura",
            "last_updated": 1554425453,
            "renting": 1,
            "returning": 1,
            "uid": "56"
            },
          "free_bikes": 6,
          "id": "67d54f4e5ba728b426b6543eb38ba49a",
          "latitude": -33.3980103,
          "longitude": -70.6007646,
          "name": "V35 - Municipalidad de Vitacura",
          "timestamp": "2019-04-05T00:51:05.590000Z"
          },
          {
            "empty_slots": 7,
            "extra": {
              "address": "S25 - Plaza de Armas",
              "last_updated": 1554425460,
              "renting": 1,
              "returning": 1,
              "uid": "77"
            },
            "free_bikes": 8,
            "id": "2fccf0c72966d33e41a70bc38d539a3c",
            "latitude": -33.4367061,
            "longitude": -70.6498287,
            "name": "S25 - Plaza de Armas",
            "timestamp": "2019-04-05T00:51:05.887000Z"
          }
        ]
      }
    }
    '''
  end

  describe :initialize do
    it "raises an exception when initialized with a blank base_url" do
      expect { CityBike::Client.new("", network) }.to raise_error(ArgumentError, "base_url cannot be blank")
    end

    it "raises an exception when initialized with a blank network" do
      expect { CityBike::Client.new(base_url, "") }.to raise_error(ArgumentError, "network cannot be blank")
    end
  end

  describe :list_stations do
    let(:expected_url) { "http://api.citybik.es/v2/networks/bikesantiago" }
    it "gets from the correct url" do
      stub_request(:get, expected_url).to_return(body: mock_result)

      client.list_stations

      expect(a_request(:get, expected_url)).to have_been_made.once
    end

    it "returns an array of stations" do
      stub_request(:get, expected_url).to_return(body: mock_result)

      result = client.list_stations
      expect(result).to be_a(Array)
      expect(result[0].keys).to include("name")
    end

    context "with an unknown network" do
      let(:network) { "foo" }
      let(:client) { CityBike::Client.new(base_url, network) }

      let(:not_found_url) { "http://api.citybik.es/v2/networks/foo" }

      it "raises a NotFoundError exception" do
        stub_request(:get, not_found_url).to_return(status: 404)

        expect { client.list_stations }.to raise_error(CityBike::NotFoundError)
      end
    end
  end
end
