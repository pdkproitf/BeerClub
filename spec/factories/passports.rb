FactoryGirl.define do
  factory :passport do
    name  {Faker::Name.name}
    association :customer, factory: :customer
  end
end
