RSpec.describe StationLog do
  context "creating a log" do
    let(:station) { create(:station) }
    let(:last_updated) { Time.at(1554581824).utc.to_datetime }

    context "when the entry already exists" do
      before do
        create(:station_log, station: station, last_update: last_updated)
      end

      it "does not create a new entry" do
        expect{ StationLog.create_log(station, last_updated, 1, 1) }.to_not change{ StationLog.count }
      end
    end

    context "when the entry does not exist" do
      it "create a new entry" do
        expect{ StationLog.create_log(station, last_updated, 1, 1) }.to change{ StationLog.count }.by(1)
      end
    end
  end
end
