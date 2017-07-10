FactoryGirl.define do
  temp = Faker::Internet.password(8)

  factory :user do
    name                  Faker::Name.unique.name
    sequence :email do |n|
    "email#{n}@factory.com"
    end
    password              temp
    password_confirmation temp
    association :role, factory: :role
  end

  factory :invalid_user, parent: :user do
    email nil
  end
end
