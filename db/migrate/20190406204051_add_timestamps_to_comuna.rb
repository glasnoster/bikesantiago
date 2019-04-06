class AddTimestampsToComuna < ActiveRecord::Migration[5.2]
  def change
    change_table :comunas do |t|
      t.timestamps
    end
  end
end
