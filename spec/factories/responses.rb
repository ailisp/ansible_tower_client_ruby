FactoryGirl.define do
  factory :response_collection, :class => "Hash" do
    count    2
    "next"   ""
    previous ""
    klass    ""
    results  { count.times.collect { build(:response_instance, :klass => klass) } }

    initialize_with { AnsibleTowerClient::FactoryHelper.stringify_attribute_keys(attributes) }
  end

  factory :response_instance, :class => "Hash" do
    sequence(:id)
    klass      ""
    type       { AnsibleTowerClient::FactoryHelper.underscore_string(klass.namespace.last) }
    name       { "#{type}-#{id}" }
    url        { "/api/v1/#{klass.endpoint}/#{id}/" }
    related    { {"survey_spec" => "example.com/api", 'inventory' => 'inventory link'} }
    limit      { "" }

    trait(:description)             { sequence(:description) { |n| "description_#{n}" } }
    trait(:extra_vars)              { extra_vars { {:option => "lots of options"}.to_json } }
    trait(:instance_id)             { instance_id SecureRandom.uuid }
    trait(:inventory_id)            { inventory { rand(500) } }

    trait(:group)                   { [description, inventory_id] }
    trait(:host)                    { [description, instance_id, inventory_id] }
    trait(:job_template)            { [description, extra_vars] }

    initialize_with { AnsibleTowerClient::FactoryHelper.stringify_attribute_keys(attributes) }
  end
end