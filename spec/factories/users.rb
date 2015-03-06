# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password "changeme"
    password_confirmation "changeme"
    # required if the Devise Confirmable module is used
    # confirmed_at Time.now
  end

  factory :admin_user, parent: :user, class: User do
    after(:create) do |user|
      user.admin!
    end
  end
end
