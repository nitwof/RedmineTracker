FactoryGirl.define do
  factory :action do
    sequence(:name) { |n| "Action #{n}" }
    started_at Time.current
    stopped_at nil
    sequence(:project_id)
    sequence(:issue_id)
    sequence(:activity_id)
  end
end
