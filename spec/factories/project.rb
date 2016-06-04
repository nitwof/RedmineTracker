FactoryGirl.define do
  factory :project do
    sequence(:id)
    sequence(:name) { |n| "Project #{n}" }
    sequence(:identifier) { |n| "#{n}#{n}#{n}#{n}#{n}" }
    sequence(:description) { |n| "Description for project #{n}" }
    homepage ''
    status 1
    created_on 10.hours.ago
    updated_on 10.hours.ago
  end
end
