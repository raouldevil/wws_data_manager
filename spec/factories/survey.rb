require 'factory_girl'

FactoryGirl.define do
  factory :survey do
    title 'Some survey'
    sg_id 112323
    status 'In Design'
    survey_created '2013/30/12 13:04'

  end
end