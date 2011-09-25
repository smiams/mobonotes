FactoryGirl.define do
  factory :label, :class => Label do
    name "Factory'd Label"
    association :user, :factory => :user
  end
end