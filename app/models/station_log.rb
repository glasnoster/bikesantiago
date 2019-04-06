class StationLog < ApplicationRecord
  belongs_to :station

  def self.create_log(station, last_update, free_bikes, empty_slots)
    log_exists = StationLog.where(station: station, last_update: last_update).present?

    return if log_exists

    StationLog.create(
      station:     station,
      last_update: last_update,
      free_bikes:  free_bikes,
      empty_slots: empty_slots)
  end

end
