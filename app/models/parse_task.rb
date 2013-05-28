class Question
  attr_accessor :id, :title, :options
  
  def initialize(an_id, a_title)
  	self.id = an_id
  	self.title = a_title
  end

  # From activesupport but edited

  def underscore(camel_cased_word)
    word = camel_cased_word.to_s.dup
    word.gsub!(/'/, '')
    word.gsub!(/"/, '')
    word.gsub!(/,/, '')
    word.gsub!(/\?+/, '')
    word.gsub!(/\s+/, '_')
    word.gsub!(/_+/, '_')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.gsub!(/_+/, '_')
    word.downcase!
    word
  end

end

class SingleAnswer < Question

  def get_header
  	return underscore(self.title)
  end

  def get_responses(answers)

  end
end

class FlatAnswer < Question

	def initialize(an_id, a_title, options)
		self.id = an_id
		self.title = a_title
		self.options = options
	end

  def get_header
  	return underscore(self.title)
  end

  def get_responses(answers)

  end
end

class MultiAnswer < Question

	def initialize(an_id, a_title, options)
		self.id = an_id
		self.title = a_title
		self.options = options
	end

  def get_header
		titleString = ''
  	self.options.each do |option|
  		titleString.concat underscore(',' + self.title + '_' + option['title']['English'] + ',')
  	end
  	return titleString
	
  end

  def get_responses(answers)

  end
end

class ParseTask

	require 'json'
	require 'csv'

	def self.parseSurveyQuestions(q_json_string)
		questions_array = []
		q_json = JSON.parse(q_json_string.to_s)
	  q_json['data'].each do |question|
			case question['_subtype']
			when 'textbox', 'essay', 'menu'
				questions_array << SingleAnswer.new(question['id'], question['title']['English'])
			when 'radio', 'checkbox'
				questions_array << FlatAnswer.new(question['id'], question['title']['English'], question['options'])
			when 'multi_textbox', 'cont_sum'
				questions_array << MultiAnswer.new(question['id'], question['title']['English'], question['options'])
			end
	  end
		return questions_array

	end

	def self.parseSurveyResponses(questions_array, r_json_string)
		responses_array = []

		question_ids = []
  	questions_array.each do |question|
  	  question_ids << question.id
  	end
		
		r_json = JSON.parse(r_json_string)
	  r_json['data'].each_with_index do |response, i|
 			
	  	question_ids.each do |q_id|
		  	response.each do |answer|
		  	  if answer[0].include?("question(#{q_id})")
			  		puts "Answer key: #{answer[0]} value: #{answer[1]}"
		  	  	responses_array[i] = answer
		  	  end
		  	end
		  end

	  end

	  return responses_array
		
	end

	def self.parseCSV(q_json_string, r_json_string)

		CSV.generate do |csv|
	  
			questions_array = parseSurveyQuestions(q_json_string)
			answers_array = parseSurveyResponses(questions_array, r_json_string)

			row = ''

			questions_array.each do |question|
				row.concat ',' + question.get_header
			end

			puts '##########Row###############'
			puts row

			csv << row

		end
		
	end
	


end



