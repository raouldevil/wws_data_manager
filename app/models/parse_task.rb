class ParseTask

	require 'json'
	require 'csv'

	def parseSurveyQuestions(q_json_string)
		q_json = JSON.parse(q_json_string)
		csv_string = CSV.generate do |csv|
		  q_json['data'].each_with_index do |question, i|
		  	csv << question[i]['title']['English']
		  end
		end
		return csv_string

	end

	def parseSurveyResponses
		
	end

end
