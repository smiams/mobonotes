FactoryGirl.define do
  factory :label, :class => Label do
    name "Factory'd Label"
  end

  factory :label_with_tasks_for_user, :class => Label do
    name "Factory'd Label with Current Tasks for User"

    association :user, :factory => :user, :strategy => :build

    after(:build) do |label, evaluator|
      beginning_of_yesterday = Time.now.beginning_of_day - 1.day
      end_of_yesterday = Time.now.end_of_day - 1.day

      beginning_of_today = Time.now.beginning_of_day
      end_of_today = Time.now.end_of_day

      beginning_of_tomorrow = Time.now.beginning_of_day + 1.day
      end_of_tomorrow = Time.now.end_of_day + 1.day

      label.tasks << build(:task, :name => "one", :rolling => false, :start_at => beginning_of_yesterday, :completed_at => beginning_of_yesterday, :user => label.user)
      label.tasks << build(:task, :name => "two", :rolling => true, :start_at => beginning_of_yesterday, :completed_at => beginning_of_yesterday, :user => label.user)
      label.tasks << build(:task, :name => "three", :rolling => false, :start_at => beginning_of_yesterday, :user => label.user)

      # Label.with_current_tasks_for_user should return these...
      label.tasks << build(:task, :name => "six", :rolling => true, :start_at => beginning_of_yesterday, :user => label.user)
      label.tasks << build(:task, :name => "four", :rolling => false, :start_at => beginning_of_today, :completed_at => beginning_of_today, :user => label.user)
      label.tasks << build(:task, :name => "five", :rolling => false, :start_at => beginning_of_today, :user => label.user)
      label.tasks << build(:task, :name => "seven", :rolling => true, :start_at => beginning_of_yesterday, :completed_at => beginning_of_today, :user => label.user)
      label.tasks << build(:task, :name => "eight", :rolling => true, :start_at => beginning_of_today, :user => label.user)
      label.tasks << build(:task, :name => "nine", :rolling => true, :start_at => beginning_of_today, :completed_at => beginning_of_today, :user => label.user)

      label.tasks << build(:task, :name => "ten", :rolling => false, :start_at => beginning_of_tomorrow, :completed_at => beginning_of_tomorrow, :user => label.user)
      label.tasks << build(:task, :name => "eleven", :rolling => false, :start_at => beginning_of_tomorrow, :user => label.user)
      label.tasks << build(:task, :name => "twelve", :rolling => true, :start_at => beginning_of_tomorrow, :user => label.user)
      label.tasks << build(:task, :name => "thirteen", :rolling => true, :start_at => beginning_of_tomorrow, :completed_at => beginning_of_tomorrow, :user => label.user)
    end
  end
end