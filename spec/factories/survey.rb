require 'factory_girl'

FactoryGirl.define do
  factory :survey do
    title 'Some survey'
    sg_id 1176375
    status 'In Design'
    survey_created '2013/30/12 13:04'
    questions_json '{"result_ok":"true,"data":[{"id":"1", "title":{"English":"Question - Checkbox"}]}'
    responses_json '{"result_ok":"true,"data":[{"id":"1", "[question(1), option(0)]":""}]}'

  end
end