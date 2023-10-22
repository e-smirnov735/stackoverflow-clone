FactoryBot.define do
  factory :answer do
    body { 'MyText' }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      files do
        [Rack::Test::UploadedFile.new(Rails.root.join('spec/rails_helper.rb')),
         Rack::Test::UploadedFile.new(Rails.root.join('spec/spec_helper.rb'))]
      end
    end
  end
end
