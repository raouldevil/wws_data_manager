require 'spec_helper'

describe Survey do

	it "should have a valid factory" do
  	 FactoryGirl.create(:survey).should be_valid
  end

  it "should have a title" do
  	 FactoryGirl.build(:survey, title: nil).should_not be_valid
  end

  it 'should have an id' do
    FactoryGirl.build(:survey, sg_id: nil).should_not be_valid
  end

  it "should have a created date" do
    FactoryGirl.build(:survey, survey_created: nil).should_not be_valid
  end

  it "should have a status" do
    FactoryGirl.build(:survey, status: nil).should_not be_valid
  end

end
