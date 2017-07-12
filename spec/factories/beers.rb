FactoryGirl.define do
  factory :beer do
    manufacurter  { Faker::Educator.campus }
    name          { Faker::Name.unique.name }
    country       { Faker::Address.country }
    price         { Faker::Number.decimal(2) }
    description   { Faker::Lorem.paragraph(2) }
    association :category, factory: :category
  end
end
