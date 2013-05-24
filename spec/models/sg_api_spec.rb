require 'spec_helper'

describe SgApi do
	describe "SG api transactions" do
		it "should return data from the server with a correct id" do
		  json_response = SgApi.get_sg_survey_responses(survey_id)
		  json_response["result_ok"].should eq true 
		end
	  
	end
end
