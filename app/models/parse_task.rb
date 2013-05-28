class Question
  attr_accessor :id, :title, :options, :answer_set
  
  def initialize args
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
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

  def get_responses
  	self.answer_set.each do |answer|
  		if answer[0].include?("question(#{self.id})")
  			return answer[1]
  		end
  	end
  end
end

class FlatAnswer < Question

  def get_header
  	return underscore(self.title)
  end

  def get_responses
  	answer_string = ''
  	self.answer_set.each do |answer|
  		if answer[0].include?("question(#{self.id})")
  			answer_string << answer[1] + '; '
  		end
  		return answer_string.chomp
  	end
  end
end

class MultiAnswer < Question

  def get_header
		title_string = []
  	self.options.each do |option|
  		title_string << underscore(',' + self.title + '_' + option['title']['English'] + ',')
  	end
  	return title_string
	
  end

	def get_responses
		answer_string = []
		self.answer_set.each do |answer|
			if answer[0].include?("question(#{self.id})")
				answer_string << answer[1]
			end
			return answer_string
		end
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
				questions_array << SingleAnswer.new(id: question['id'], title: question['title']['English'])
			when 'radio', 'checkbox'
				questions_array << FlatAnswer.new(id: question['id'], title: question['title']['English'], options: question['options'])
			when 'multi_textbox', 'cont_sum'
				questions_array << MultiAnswer.new(id: question['id'], title: question['title']['English'], options: question['options'])
			end
	  end
		return questions_array

	end

	def self.parseSurveyResponses(questions_array, r_json_string)
		responses_array = []

		questions_info = []
  	questions_array.each do |question|
  	  questions_info << {id: question.id, type: question.class}
  	end
		
		r_json = JSON.parse(r_json_string)
	  r_json['data'].each_with_index do |response, i|
	  	responses_array[i] = []
	  	questions_info.each do |q_info|
	  		puts "#### This is the type: #{q_info}"
		  	response.each do |answer|
		  		answer_set = q_info[:type].new(answer_set: [])
		  	  if answer[0].include?("question(#{q_info[:id]})")
			  		answer_set.id = q_info[:id]
			  		puts "Answer key: #{answer[0]} value: #{answer[1]}"
		  	  	answer_set.answer_set << answer
		  	  end
		  	  if answer_set.answer_set != [] then responses_array[i] << answer_set end
		  	end
		  end
	  end

	  return responses_array
		
	end

	def self.parseCSV(q_json_string, r_json_string)

		CSV.generate do |csv|
	  
			questions_array = parseSurveyQuestions(q_json_string)
			responses_array = parseSurveyResponses(questions_array, r_json_string)

			row = []
			questions_array.each do |question|
				row << question.get_header
			end
			csv << row.flatten

			row = []
			responses_array.each do |response|
				response.each do |answer_set|
					row << answer_set.get_responses
				end
			end
			csv << row.flatten

		end
		
	end
	


end



