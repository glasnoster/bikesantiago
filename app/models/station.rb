class Station < ApplicationRecord
  validates :name, presence: true

  scope :by_name, -> name { where("name ILIKE ?", "%#{sanitize_sql_like(name)}%") }
end
