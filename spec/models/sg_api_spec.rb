require 'spec_helper'

describe SgApi do
	describe 'SG api transactions' do

		it 'should not return a survey from the server with an incorrect id' do
			VCR.use_cassette 'models/sg_api/survey_error' do
			  json_response_string = SgApi.get_sg_survey('aa')
			  json_response = JSON.parse(json_response_string)
			  json_response['result_ok'].should eq false
			end
		end

		it 'should return a survey from the server with a correct id' do
			VCR.use_cassette 'models/sg_api/survey_success' do
			  json_response_string = SgApi.get_sg_survey('1176375')
			  json_response = JSON.parse(json_response_string)
			  json_response['result_ok'].should eq true
			end
		end
		
		it 'should not return responses from the server with an incorrect id' do
			VCR.use_cassette 'models/sg_api/responses_error' do
			  json_response_string = SgApi.get_sg_survey_responses('aa')
			  json_response = JSON.parse(json_response_string)
			  json_response['result_ok'].should eq false
			end
		end

		it 'should return responses from the server with a correct id' do
			VCR.use_cassette 'models/sg_api/responses_success' do
			  json_response_string = SgApi.get_sg_survey_responses('1176375')
			  json_response = JSON.parse(json_response_string)
			  json_response['result_ok'].should eq true
			end
		end
	  
	end
end
