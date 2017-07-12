FactoryGirl.define do
  factory :category do
    id      Faker::Number.digit
    name    Faker::Name.name
  end

  factory :invalid_category, parent: :category do
    name nil
  end
end
