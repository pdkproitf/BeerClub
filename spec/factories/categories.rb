FactoryGirl.define do
  factory :category do
    name {Faker::Name.name}
  end

  factory :invalid_category, parent: :category do
    name nil
  end
end
