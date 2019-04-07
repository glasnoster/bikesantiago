class AddFieldsToStations < ActiveRecord::Migration[5.2]
  def change
    change_table :stations do |t|
      t.datetime :last_update, index: true
      t.integer :empty_slots
      t.integer :free_bikes
    end
  end
end
