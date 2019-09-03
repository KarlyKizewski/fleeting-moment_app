FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "dummyEmail#{n}@gmail.com"
    end
    password { "secretPassword" }
    password_confirmation { "secretPassword" }
  end

  factory :moment do
    message { "hello" }
    picture { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'picture.jpg').to_s, 'image/jpg') }
    
    association :user
  end
end