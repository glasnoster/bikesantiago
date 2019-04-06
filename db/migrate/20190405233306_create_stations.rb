class CreateStations < ActiveRecord::Migration[5.2]
  def change
    create_table :stations do |t|
      t.string :name
      t.string :citybikes_id
      t.string :citybikes_uid

      t.timestamps
    end
  end
end
