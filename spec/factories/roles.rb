FactoryGirl.define do
  factory :role do
    name Role.find_or_create_by(name: 'Admin')
  end
end
