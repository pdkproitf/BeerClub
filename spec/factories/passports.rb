FactoryGirl.define do
  factory :passport do
    name  {Faker::Name.name}
    association :user, factory: :user
  end
end
