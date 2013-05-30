class SgApi
	# require 'webmock'
	require 'net/http'
	require 'json'

  # WebMock.allow_net_connect!

	def self.get_sg_survey(survey_id)
  	uri = URI.parse(
  		'https://restapi.surveygizmo.com/v3/survey/' + survey_id.to_s + 
  		'?user:pass=' + self.username + ':' + self.password
  	)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request).body
		return response
  end

	def self.get_sg_survey_questions(survey_id)
  	uri = URI.parse(
  		'https://restapi.surveygizmo.com/v3/survey/' + survey_id.to_s  + 
  		'/surveyquestion?user:pass=' + self.username + ':' + self.password
  	)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request).body
		return response
  end


  def self.get_sg_survey_responses(survey_id, page)
		uri = URI.parse(
			'https://restapi.surveygizmo.com/v3/survey/' + survey_id.to_s  + 
			'/surveyresponse/?' + page + 
			'resultsperpage=500&user:pass=' + self.username + ':' + self.password
		)
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request = Net::HTTP::Get.new(uri.request_uri)
		response = http.request(request).body
		return response
  end

  private

  def self.username 
  	'user@world-wize.com'
  end

  def self.password
  	'SG11s1z'
  end	


end
