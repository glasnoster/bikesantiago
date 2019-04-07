RSpec.shared_examples "a usage report" do
  before do
    station1 = create(:station, name: "Station 1")
    station2 = create(:station, name: "Station 2")

    create(:station_log, station: station1, created_at: t1, free_bikes: 1, empty_slots: 2)
    create(:station_log, station: station2, created_at: t1, free_bikes: 2, empty_slots: 2)
    create(:station_log, station: station1, created_at: t2, free_bikes: 1, empty_slots: 1)
  end

  it "groups the timestamps into minute buckets" do
    expect(StationLog.report_for(Station.all, last).map(&:timestamp).count).to eq(2)
  end

  it "sums the number of free bikes in each slot" do
    expect(StationLog.report_for(Station.all, last).map(&:total_free_bikes)).to eq([1, 3])
  end

  it "sums the number of empty slots in each slot" do
    expect(StationLog.report_for(Station.all, last).map(&:total_empty_slots)).to eq([1, 4])
  end

  it "filters by station" do
    s = Station.where(name: "Station 2")
    expect(StationLog.report_for(s, last).map(&:timestamp).count).to eq(1)
  end
end

RSpec.describe StationLog do
  describe "#report_for" do

    context "the last hour" do
      let(:t1) { Time.now }
      let(:t2) { t1 - 2.minutes }
      let(:last) { :hour }

      it_behaves_like "a usage report"
    end

    context "the last day" do
      let(:t1) { Time.now }
      let(:t2) { t1 - 2.hours }
      let(:last) { :day }

      it_behaves_like "a usage report"
    end
  end

end
