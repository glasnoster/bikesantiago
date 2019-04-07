class StationLog < ApplicationRecord
  belongs_to :station
  validates :station, presence: true

  def self.usage(stations, last=:hour)

  end

end
