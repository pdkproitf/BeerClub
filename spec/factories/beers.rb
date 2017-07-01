FactoryGirl.define do
  factory :beer do
    manufacurter  {Faker::Name.name}
    name          {Faker::Name.name}
    country       {Faker::Address.country}
    price         {Faker::Number.decimal(2)}
    description   {Faker::Lorem.paragraphs}
    association :category, factory: :category
  end
end
