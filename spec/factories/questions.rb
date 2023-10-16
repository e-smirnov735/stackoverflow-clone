FactoryBot.define do
  sequence :body do |n|
    "body from #{n} question"
  end
  factory :question do
    title { 'MyString' }
    body
    user

    trait :invalid do
      title { nil }
      body { nil }
    end

    trait :freeze do
      title { 'MyTitle' }
      body { 'MyBody' }
    end
  end
end
