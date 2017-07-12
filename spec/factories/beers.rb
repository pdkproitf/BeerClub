FactoryGirl.define do
  factory :beer do
    manufacurter  { Faker::Name.name }
    name          { Faker::Name.name }
    country       { Faker::Address.country }
    price         { Faker::Number.decimal(2) }
    description   { Faker::Lorem.paragraph(2) }
    association :category, factory: :category
  end
end
