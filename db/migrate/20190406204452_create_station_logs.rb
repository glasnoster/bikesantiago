class CreateStationLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :station_logs do |t|
      t.datetime :last_update, index: true
      t.integer :empty_slots
      t.integer :free_bikes
      t.belongs_to :station, index: true

      t.timestamps
    end
  end
end
