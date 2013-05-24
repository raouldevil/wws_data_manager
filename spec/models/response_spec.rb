require 'spec_helper'

describe Response do

	it "should have a valid factory" do
  	 FactoryGirl.create(:response).should be_valid
  end

  it "should have a title" do
  	 FactoryGirl.build(:response, sg_response_id: nil).should_not be_valid
  end

  it 'should have an id' do
    FactoryGirl.build(:response, survey_id: nil).should_not be_valid
  end

  it "should have a created date" do
    FactoryGirl.build(:response, json_response: nil).should_not be_valid
  end


end
