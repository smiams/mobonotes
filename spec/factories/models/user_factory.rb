FactoryGirl.define do
  factory :user, :class => User do
    sequence :email_address do |seq|
      "person-#{seq}@mobonotes.com"
    end

    password "password"
    password_confirmation "password"
  end
end