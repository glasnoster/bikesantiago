RSpec.describe Station do
  context "creating a new Station" do
    let(:valid_params) { {name: "Station 1"} }
    it "is valid with valid params" do
      expect(Station.create(valid_params)).to be_valid
    end

    it "is invalid with invalid params" do
      expect(Station.create()).to_not be_valid
    end
  end

  describe ".by_name" do
    before do
      create(:station, name: "Station 1")
      create(:station, name: "Station 2")
      create(:station, name: "Station 3")
    end

    it { expect(Station.by_name("Station").count).to eq(3) }
    it { expect(Station.by_name("Station 1").count).to eq(1) }
  end

end
