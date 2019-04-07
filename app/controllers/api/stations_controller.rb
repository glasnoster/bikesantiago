class Api::StationsController < ApplicationController
  include StationSearchable

  before_action :set_stations, only: :index
end
