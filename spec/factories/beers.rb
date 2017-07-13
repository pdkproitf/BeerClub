FactoryGirl.define do
  factory :beer do
    association :category, factory: :category
    name          Faker::Name.unique.name
    manufacurter  Faker::Educator.campus
    country       Faker::Address.country
    price         Faker::Number.decimal(2)
    description   Faker::Lorem.paragraph(2)
  end
end
