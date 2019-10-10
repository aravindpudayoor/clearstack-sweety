require 'faker'
FactoryGirl.define do
  factory :glucose_level do
    value Faker::Number.number(digits: 3).to_i
    user nil
  end
end
