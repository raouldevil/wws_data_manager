class SgApi
	require 'webmock'
	require 'net/http'
	require 'json'

  WebMock.allow_net_connect!

	def self.get_sg_survey
  	uri = URI.parse('https://restapi.surveygizmo.com/v3/survey/' + survey_id + '?user:pass=' + username + ':' + password)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request).body
		return response
  end

	def self.get_sg_survey_questions(survey_id)
  	uri = URI.parse('https://restapi.surveygizmo.com/v3/survey/' + survey_id + '/surveyquestion?user:pass=' + username + ':' + password)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request).body
		return response
  end


  def self.get_sg_survey_responses(survey_id)
		uri = URI.parse('https://restapi.surveygizmo.com/v3/survey/' + survey_id + '/surveyresponse/?user:pass=' + username + ':' + password)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request).body
		return response
  end

  private

  def username 
  	'user@world-wize.com'
  end

  def password
  	'SG11s1z'
  end	


end
