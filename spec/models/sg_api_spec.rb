require 'spec_helper'

describe SgApi do
	describe 'SG api transactions' do
		
		it 'should not return responses from the server with an incorrect id' do
		  json_response = SgApi.get_sg_survey_responses('aa')
		  json_response['result_ok'].should eq true 
		end

		it 'should return responses from the server with a correct id' do
		  json_response = SgApi.get_sg_survey_responses('1176375')
		  json_response['result_ok'].should eq true 
		end

		it 'should return surveys from the server' do
		  json_response = SgApi.get_sg_surveys
		  json_response['result_ok'].should eq true 
		end
	  
	end
end
