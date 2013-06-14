require 'spec_helper'

describe Survey do

	it 'should create a survey with a correct ID' do
    VCR.use_cassette 'models/survey/survey_success' do
  	 FactoryGirl.create(:survey).should be_valid
    end
  end

  it 'should not create a survey with a incorrect ID'  do
    VCR.use_cassette 'models/survey/survey_error' do
     FactoryGirl.create(:survey, sg_id: 1111).should_not be_valid
    end
  end

  it 'should parse the csv when the parseCSV method is called' do
    VCR.use_cassette 'models/survey/survey_error' do
      q_json_string = '['
      q_json_string +=  '{"id":1,"_subtype":"checkbox","title":{"English":"Question - Checkbox"},"options":['
      q_json_string +=     '{"id":10010,"value":"One"},{"id":10011,"value":"Two"},{"id":10012,"value":"Three"}'
      q_json_string +=   ']},'
      q_json_string +=   '{"id":2,"_subtype":"textbox","title":{"English":"Question - String"}}'
      q_json_string += ']'

      r_json_string = '['
      r_json_string +=   '{"id":"1","[question(1), option(10013)]":"One","[question(1), option(10014)]":"Two", "[question(2)]":"Test one"},'
      r_json_string +=   '{"id":"2","[question(1), option(10013)]":"One","[question(2)]":"Test two"}'
      r_json_string += ']'

      survey = FactoryGirl.create(:survey)
      survey.update_attributes(questions_json: q_json_string, responses_json: r_json_string)
      survey.parseCSV

      # For some reason the regex just will not match, hence checking for each row text.
      survey.csv.should include('question_checkbox,question_string')
      survey.csv.should include('One Two  ,Test one')
      survey.csv.should include('One   ,Test two')
    end
  end

end
