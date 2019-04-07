RSpec.describe Api::UsagesController do
  describe "GET index" do
    context "without params" do
      it "searches all the stations" do
        expect(Station).to receive(:all)

        get :show
      end

      it "generates the report for the last hour" do
        expect(StationLog).to receive(:report_for).with(anything, :hour)

        get :show
      end
    end

    context "with search params" do
      let(:name_param) { "Providencia" }
      let(:comuna_param) { "Vitacura" }

      it "filters by name when a name is supplied" do
        expect(Station).to receive(:by_name).with(name_param)

        get :show, params: {name: name_param}
      end

      it "filters by comuna when a comuna is supplied" do
        expect(Comuna).to receive(:by_name).with(comuna_param)

        get :show, params: {comuna: comuna_param}
      end

      it "generates the last day's usage when the last param is set to day" do
        expect(StationLog).to receive(:report_for).with(anything, :day)

        get :show, params: {last: :day}
      end
    end
  end
end
