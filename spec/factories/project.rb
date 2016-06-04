FactoryGirl.define do
  factory :project do
    id 64
    name 'Delivery GURU'
    identifier 'deliv'
    description 'Создание системы автоматизации доставки'
    status 1
    created_at Time.current
    updated_at Time.current
    association :parent, factory: :project_parent
  end

  factory :project_parent do
    id 8
    name 'NYAN'
  end
end
