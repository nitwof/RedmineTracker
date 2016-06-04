FactoryGirl.define do
  factory :issue do
    sequence(:id)
    sequence(:subject) { |n| "Subject #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    start_date 10.hours.ago
    done_ratio 0
    created_on 24.hours.ago
    updated_on 10.hours.ago
  end
end
