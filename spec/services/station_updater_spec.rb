require 'webmock/rspec'

describe StationUpdater do
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
        subject.update_stations!

        expect(Station.all.map(&:name)).to include("Municipalidad de Vitacura")
      end

      it "correctly sets the station location" do
        subject.update_stations!

        expect(Station.all.map(&:location).map(&:to_s)).to include("POINT (-70.57866096496582 -33.38787959704519)")
      end

      context "when a comuna for the station exists" do
        it "links the comuna to the station" do
          vitacura = create(:vitacura, name: "Vitacura")
          subject.update_stations!

          expect(Station.all.map(&:comuna)).to include(vitacura)
        end
      end
    end

    context "when a station is already in the database" do
      let(:existing_station) { stations_list[0] }
      let(:station_id) { existing_station["id"] }

      before do
        create(:station, citybikes_id: station_id, name: "S1", free_bikes: 0, empty_slots: 0)
      end

      it "does not create a new entry" do
        expect { subject.update_stations! }.to change { Station.count }.by(1)
      end

      it { expect { subject.update_stations! }.to change { Station.find_by_citybikes_id(station_id).free_bikes } }
      it { expect { subject.update_stations! }.to change { Station.find_by_citybikes_id(station_id).empty_slots } }
      it { expect { subject.update_stations! }.to change { Station.find_by_citybikes_id(station_id).last_update } }
    end

    it "creates a StationLog entry for each log" do
      expect { subject.update_stations! }.to change { StationLog.count }.by(2)
    end


    it "logs ApiErrors" do
      message = "test message"
      allow(client).to receive(:list_stations).and_raise(CityBikes::ApiError.new(message))
      expect(Rails.logger).to receive(:error).with(message)

      subject.update_stations!
    end

  end
end
