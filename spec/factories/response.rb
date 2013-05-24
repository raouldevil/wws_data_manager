require 'factory_girl'

FactoryGirl.define do

  factory :response do
    survey_id 1
    sg_response_id 2
    json_response '[{"response_ok":true},{"response_ok":true}]'

  end
end