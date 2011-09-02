FactoryGirl.define do
  factory :user, :class => User do
    email_address "sean.iams@gmail.com"
    password "password"
    password_confirmation "password"
  end
end