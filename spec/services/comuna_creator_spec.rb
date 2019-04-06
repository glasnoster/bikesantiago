require 'webmock/rspec'

describe ComunaCreator do
  let(:base_url) { "test" }
  let(:client) { MeteoChile::Client.new(base_url) }

  describe "#call"

  describe "#from_file" do
    let(:path) { 'db/seeds/rm_comunas.json' }
    subject { ComunaCreator.from_file(path) }

    it "creates an instance with an client that reads from a local file" do
      expect(subject.client).to be_a(OpenStruct)
    end

    it "creates comunas from a file" do
      expect { subject.create_comunas! }.to change{ Comuna.count }.by(52)
    end
  end

  describe :create_comunas! do
    let(:comunas) { RGeo::GeoJSON.decode(file_fixture("comuna_api_response.json").read) }
    let(:client) { instance_double("MeteoChile::Client", list_comunas: comunas) }
    subject { ComunaCreator.new(client) }

    it "calls the api" do
      expect(client).to receive(:list_comunas)

      subject.create_comunas!
    end

    it "only inserts comunas in RM" do
      expect { subject.create_comunas! }.to change{ Comuna.count }.by(1)
    end
  end
end
