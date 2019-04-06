class Station < ApplicationRecord
  belongs_to :comuna, optional: true

  validates :name, presence: true

  scope :by_name, -> name { where("name ILIKE ?", "%#{sanitize_sql_like(name)}%") }

end
