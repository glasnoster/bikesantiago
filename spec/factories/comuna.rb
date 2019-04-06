FactoryBot.define do
  factory :comuna do
    name { "Dummy Comuna" }

    factory :vitacura do
      name { 'Vitacura' }
      bounds { "MULTIPOLYGON (((-70.56939125061035 -33.37863424823648, -70.59874534606934 -33.38981454563581, -70.60209274291992 -33.40808693568209, -70.5596923828125 -33.39389929566411, -70.56939125061035 -33.37863424823648)))" }
    end
  end
end
