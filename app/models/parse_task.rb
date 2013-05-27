class ParseTask

	require 'json'
	require 'csv'



	def self.parseSurveyQuestions(q_json_string)
		questions_array = []
		q_json = JSON.parse(q_json_string)
	  q_json['data'].each do |question|
  		case question['_subtype']
  		when 'textbox' || 'essay' || 'menu'
  			questions_array[i] << SingleAnswer.new(question['id'], question['title']['English'])
  		when 'radio' || 'checkbox'
  			questions_array[i] << FlatAnswer.new(question['id'], question['title']['English'], question['options'])
  		when 'multi_textbox' || 'cont_sum'
  			questions_array[i] << MultiAnswer.new(question['id'], question['title']['English'], question['options'])
	  end

		return questions_array

	end

	def self.parseSurveyResponse(questions_array, r_json_string)
		responses_array = []
		
		r_json = JSON.parse(r_json_string)
	  r_json['data'].each_with_index do |response, i|
	  	questions_array.all.map(&:id) do |question_id|
	  	  values = response.keys.grep /^\[question\(#{question_number}\)/
	  	end

	  	answers_hash = response.keys.group_by do |complex_key|
	  	  complex_key[/^\[question\((\d+)\)/, 1]
	  	end

	  	responses_array[i] << questions_array.all.map(&:id) do |q_id|
	  	  answers_hash[q_id.to_s].map do |answer_key|
	  	    [q_id, answer_key, response[answer_key]]
	  	end

	  end

	  return responses_array
		
	end

	# CSV.generate do |csv|
	  
	# 		questions_array = self.parseSurveyQuestions(q_json_string)
	# 		row = []

	# 		questions_array.each do |question|
	# 			row.concat question.to_header_csv
	# 		end

	# 		csv << row

	# 		responses_array

	#   byugger.each do |question_id, answers|
	#     row.concat questions[question_id].to_csv(answers)
	#   end

	#   csv << row


	# end




	# answers = json['data'].first

	
	# end

	class Question
	  attr_accessor :id, :title
	  
	  def initialize(an_id, a_title)
	  	self.id = an_id
	  	self.title = a_title
	  end

	end

	class SingleAnswer < Question

	  def to_header
	    [title]
	  end

	  def to_csv( answers )
	  end
	end

	class FlatAnswer < Question
		attr_accessor :options

		def initialize(an_id, a_title, options)
			self.id = an_id
			self.title = a_title
			self.options = options
		end

	  def to_header
	    [title]
	  end

	  def to_csv( answers )
	    raise 'oops' if answers.size != 1
	    [answers.values.first]
	  end
	end

	class MultiAnswer
		attr_accessor :options

		def initialize(an_id, a_title, options)
			self.id = an_id
			self.title = a_title
			self.options = options
		end

	  def to_header
	    [title]
	  end

	  def to_csv( answers )
	    raise 'oops' if answers.size != 1
	    [answers.values.first]
	  end
	end

	# # parse file to get these
	# # types = checkbox, radio_button, text, date, numeric, dropdown, table, list

	# types = {checkbox: Flat, radio_button: Option, text: Single, date:
	# Single, numeric: Single, dropdown: Option, table: Multi, list: Flat}

	# questions = {4 => Flat.new, 7 => Single.new, 11 => Option.new, 17 =>
	# Multi.new}

	# CSV.generate do |csv|
	#   row = []

	#   byugger.each do |question_id, answers|
	#     row.concat questions[question_id].to_csv(answers)
	#   end

	#   csv << row
	# end

end
