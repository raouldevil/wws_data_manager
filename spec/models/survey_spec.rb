require 'spec_helper'

describe Survey do

	it "should create a survey with a correct ID" do
    VCR.use_cassette 'models/survey/survey_success' do
  	 FactoryGirl.create(:survey).should be_valid
    end
  end

  it "should not create a survey with a incorrect ID"  do
    VCR.use_cassette 'models/survey/survey_error' do
     FactoryGirl.create(:survey, sg_id: 1111).should_not be_valid
    end
  end

end
