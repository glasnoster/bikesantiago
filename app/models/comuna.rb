class Comuna < ApplicationRecord
  has_many :stations

  validates :name, presence: true

  scope :by_name, -> name { where("name ILIKE ?", "%#{sanitize_sql_like(name)}%") }
  scope :containing_point, -> point {
    lng, lat = case point
    when Hash
      [point[:longitude], point[:latitude]]
    end

    where(%{st_covers(comunas.bounds, ST_MakePoint(%f, %f)::geography)} % [lng, lat])
  }

end
