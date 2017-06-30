FactoryGirl.define do
  factory :user do
    name  {Faker::Name.name}
    email {Faker::Internet.email}
    password  "password"
    password_confirmation "password"
    association :role
  end

  factory :invalid_user, parent: :user do
    email nil
  end
end
