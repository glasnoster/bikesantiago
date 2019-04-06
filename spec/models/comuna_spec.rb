RSpec.describe Comuna do
  context "creating a new Comuna" do
    let(:valid_params) { {name: "Comuna 1"} }
    it "is valid with valid params" do
      expect(Comuna.create(valid_params)).to be_valid
    end

    it "is invalid with invalid params" do
      expect(Comuna.create()).to_not be_valid
    end
  end

  describe "#by_name" do
    before do
      create(:comuna, name: "Comuna 1")
      create(:comuna, name: "Comuna 2")
      create(:comuna, name: "Comuna 3")
    end

    it { expect(Comuna.by_name("Comuna").count).to eq(3) }
    it { expect(Comuna.by_name("Comuna 1").count).to eq(1) }
  end

  describe "#containing_point" do
    before do
      create(:vitacura, name: "Vitacura")
    end

    context "given a lat/lng" do
      let(:point) { {latitude: -33.38787959704519, longitude: -70.57866096496582} }

      it { expect(Comuna.containing_point(point).count).to eq(1) }
    end
  end

end
