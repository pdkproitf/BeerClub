FactoryGirl.define do
  temp = Faker::Internet.password(8)

  factory :user do
    email                 {Faker::Internet.email}
    name                  {Faker::Name.name}
    password              temp
    password_confirmation temp
    association :role, factory: :role

    factory :user_uniq_email do
      email { Faker::Internet.email }
    end
  end

  factory :invalid_user, parent: :user do
    email nil
  end

end
