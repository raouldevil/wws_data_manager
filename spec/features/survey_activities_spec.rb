require 'spec_helper'

describe 'SurveyActivities' do

  describe 'new' do

    it 'should not show the details of a survey with a bad ID' do
      visit new_survey_path
      fill_in 'Survey ID', with: 'aa#wws'
      click_button 'Find'
      page.should have_selector('div.error')
    end

    it 'should show the details of a survey with a valid ID' do
      visit new_survey_path
      fill_in 'Survey ID', with: '1176375'
      click_button 'Find'
      page.should have_selector('div.success')
      page.should have_content('Details for survey 1176375')
    end


  end

  describe 'show' do

    before(:each) do
      survey = FactoryGirl.create(:survey)
    end

    it 'should show the details of a survey' do
    	visit survey_path(survey)
    	page.should have_content('Details for survey' + survey.sg_id.to_s)
    end
  end

  describe 'index' do

    before(:each) do
      survey = FactoryGirl.create(:survey)
    end

    it 'should show a list of surveys' do

      visit surveys_path
      page.should have_content('Your Surveys')
      page.should have_content(survey.title)
    end
  end
end
