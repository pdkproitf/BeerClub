FactoryGirl.define do
  temp = Faker::Internet.password(8)

  factory :user do
    email                 Faker::Internet.email
    name                  Faker::Name.unique.name
    password              temp
    password_confirmation temp
    association :role
  end

  factory :invalid_user, parent: :user do
    email nil
  end

  factory :user_uniq_email, parent: :user do
    email    Faker::Internet.unique.email
  end
end
