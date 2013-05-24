require 'spec_helper'

describe "SurveyActivities" do
  describe "index" do

  	before(:each) do
  		@survey = FactoryGirl.create(:survey)
  	end

    it "should show a list of surveys" do

    	visit surveys_path
    	page.should have_content('Your Surveys')
    	page.should have_content(@survey.title)
    end
  end

  describe "show" do

    before(:each) do
      @survey = FactoryGirl.create(:survey)
    end

    it "should show a list of surveys" do

    	visit survey_path(@survey)
    	page.should have_content('Responses for Survey ' + @survey.sg_id.to_s)
    end
  end
end
