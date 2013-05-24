class SgApi
	require 'webmock'
	require 'net/http'
	require 'json'

  WebMock.allow_net_connect!


  def self.get_sg_survey_responses(survey_id)
		uri = URI.parse('https://restapi.surveygizmo.com/v3/survey/' + survey_id + '/surveyresponse/?user:pass=user@world-wize.com:SG11s1z')
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request).body
		return JSON.parse(response)
  end

 	def self.get_sg_surveys
   	uri = URI.parse('https://restapi.surveygizmo.com/v3/survey/?user:pass=raoul@world-wize.com:SG77s1z')
 		http = Net::HTTP.new(uri.host, uri.port)
 		http.use_ssl = true
 		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

 		request = Net::HTTP::Get.new(uri.request_uri)
 		response = http.request(request).body
 		return JSON.parse(response)

   end
end
