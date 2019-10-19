FactoryBot.define do
  factory :glucose_level do
    value {Random.rand(50..200)}
    user nil
  end
end
