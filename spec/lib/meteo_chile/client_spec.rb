require 'meteo_chile/client'
require 'webmock/rspec'
require 'rgeo-geojson'

describe MeteoChile::Client do
  let(:base_url) { "http://geonode.meteochile.gob.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Adivision_comunal_geo_ide_1&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" }
  let(:client) { MeteoChile::Client.new(base_url) }
  let(:mock_result) { file_fixture("comuna_api_response.json").read }

  describe :initialize do
    it "raises an exception when initialized with a blank base_url" do
      expect { MeteoChile::Client.new("") }.to raise_error(ArgumentError, "base_url cannot be blank")
    end
  end

  describe :list_comunas do
    let(:expected_url) { "http://geonode.meteochile.gob.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Adivision_comunal_geo_ide_1&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature" }

    it "gets from the correct url" do
      stub_request(:get, expected_url).to_return(body: mock_result)

      client.list_comunas

      expect(a_request(:get, expected_url)).to have_been_made.once
    end

    it "returns a FeatureCollection" do
      stub_request(:get, expected_url).to_return(body: mock_result)

      result = client.list_comunas
      expect(result).to be_a(RGeo::GeoJSON::FeatureCollection)
    end
  end
end