RSpec.describe Api::StationsController do
  describe "GET index" do
    context "without params" do
      it "gets all the stations" do
        expect(Station).to receive(:all)

        get :index
      end
    end

    context "with search params" do
      let(:name_param) { "Providencia" }
      let(:comuna_param) { "Vitacura" }

      it "filters by name when a name is supplied" do
        expect(Station).to receive(:by_name).with(name_param)

        get :index, params: {name: name_param}
      end

      it "filters by comuna when a comuna is supplied" do
        expect(Comuna).to receive(:by_name).with(comuna_param)

        get :index, params: {comuna: comuna_param}
      end
    end
  end
end
