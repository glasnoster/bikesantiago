class Api::UsagesController < ApplicationController
  include StationSearchable

  before_action :set_stations, only: :show

  def show
    @station_logs_aggregate = StationLog.report_for(@stations, period)
  end

  private
  def period
    param = params[:last]

    param == 'day' ? :day : :hour
  end

end
