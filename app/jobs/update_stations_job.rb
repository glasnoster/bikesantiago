class UpdateStationsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    StationUpdater.call
  end
end
