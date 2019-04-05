RSpec.describe Api::StationsController do
  describe "GET index" do
    context "without params" do
      it "gets all the stations"
    end

    context "with search params" do
      it "filters by name when a name is supplied"
      it "filters by comuna when a comuna is supplied"
    end
  end
end
