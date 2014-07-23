FactoryGirl.define do
  factory :task, :class => Task do
    name {"This is a factoried task."}

    factory :completed_task, :class => Task do
      ignore do
        completed_at Time.now
      end
    end
  end
end