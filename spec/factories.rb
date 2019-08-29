FactoryBot.define do
  factory :user do
    sequence :email do |n|
      ( "dummyEmail@gmail.com" )
    end
    password { "secretPassword" }
    password_confirmation { "secretPassword" }
  end

  factory :moment do
    message { "hello" }
    association :user
  end
end