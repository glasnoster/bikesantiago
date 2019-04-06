class AddLocationToStations < ActiveRecord::Migration[5.2]
  def change
    change_table :stations do |t|
      t.st_point :location, geographic: true
    end
  end
end
