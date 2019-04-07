class StationLog < ApplicationRecord
  belongs_to :station
  validates :station, presence: true

  def self.report_for(stations, last=:hour)
    now = Time.now
    time_window = last == :hour ? (now - 1.hours)..now : (now - 1.day)..now
    trunc_res = last == :hour ? 'minute' : 'hour'

    StationLog.joins(:station)
      .where(station: stations)
      .where(updated_at: time_window)
      .select(%{
        DATE_TRUNC('%s', station_logs.created_at) as timestamp,
        SUM(station_logs.free_bikes) as total_free_bikes,
        SUM(station_logs.empty_slots) as total_empty_slots} % trunc_res)
      .group("timestamp")
      .order("timestamp")
  end
end
