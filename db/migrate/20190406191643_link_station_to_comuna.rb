class LinkStationToComuna < ActiveRecord::Migration[5.2]
  def change
    change_table :stations do |t|
      t.belongs_to :comuna, index: true
    end
  end
end
