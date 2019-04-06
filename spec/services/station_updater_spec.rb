require 'webmock/rspec'

describe CityBikes::Client do
  let(:base_url) { "http://api.citybik.es/v2" }
  let(:network)  { "bikesantiago" }
  let(:client) { CityBikes::Client.new(base_url, network) }

  describe "#call"

  describe :update_stations! do
    let(:stations_list) { JSON.parse(file_fixture("stations_list.json").read) }
    let(:client) { instance_double("CityBikes::Client", list_stations: stations_list) }
    subject { StationUpdater.new(client) }

    it "calls the api" do
     expect(client).to receive(:list_stations)

     subject.update_stations!
    end

    context "when the stations are not in the database" do
      it "creates the stations" do
        expect { subject.update_stations! }.to change { Station.count }.by(2)
      end

      it "correctly sets the station name" do
        allow(Station).to receive(:create)
        subject.update_stations!

        expect(Station).to have_received(:create).with(hash_including(name: "Municipalidad de Vitacura"))
      end

      it "correctly sets the station location" do
        allow(Station).to receive(:create)
        subject.update_stations!

        expect(Station).to have_received(:create).with(hash_including(location: "POINT(-70.6007646 -33.3980103)"))
      end
    end

    context "when a station is already in the database" do
      let(:existing_station) { stations_list[0] }

      it "does not create a new entry" do
        create(:station, citybikes_id: existing_station["id"], name: "S1")

        expect { subject.update_stations! }.to change { Station.count }.by(1)
      end
    end

    it "logs ApiErrors" do
      message = "test message"
      allow(client).to receive(:list_stations).and_raise(CityBikes::ApiError.new(message))
      expect(Rails.logger).to receive(:error).with(message)

      subject.update_stations!
    end
  end
end
