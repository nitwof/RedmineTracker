FactoryGirl.define do
  factory :time_entry_activity do
    sequence(:id)
    sequence(:name) { |n| "Name #{n}" }
  end
end
