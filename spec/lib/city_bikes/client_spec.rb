require 'city_bikes/client'
require 'webmock/rspec'

describe CityBikes::Client do
  let(:base_url) { "http://api.citybik.es/v2" }
  let(:network)  { "bikesantiago" }
  let(:client) { CityBikes::Client.new(base_url, network) }
  let(:mock_result) { file_fixture("api_response.json").read }

  describe :initialize do
    it "raises an exception when initialized with a blank base_url" do
      expect { CityBikes::Client.new("", network) }.to raise_error(ArgumentError, "base_url cannot be blank")
    end

    it "raises an exception when initialized with a blank network" do
      expect { CityBikes::Client.new(base_url, "") }.to raise_error(ArgumentError, "network cannot be blank")
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
      let(:client) { CityBikes::Client.new(base_url, network) }

      let(:not_found_url) { "http://api.citybik.es/v2/networks/foo" }

      it "raises a NotFoundError exception" do
        stub_request(:get, not_found_url).to_return(status: 404)

        expect { client.list_stations }.to raise_error(CityBikes::NotFoundError)
      end
    end
  end
end
