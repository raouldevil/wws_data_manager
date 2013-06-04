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
    word.gsub!(/:+/, '')
    word.gsub!(/\.+/, '')
    word.gsub!(/\?+/, '')
    word.gsub!(/\!+/, '')
    word.gsub!(/\s+/, '_')
    word.gsub!(/_+/, '_')
    word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.gsub!(/_+/, '_')
    word.downcase!
    word.chomp
    word
  end

end

class SingleAnswer < Question

  def get_header
  	# Must return as array to use concat
  	return [underscore(self.title)]
  end

  def get_answer
  	# Must return as array to use concat
  	self.answer_set.each do |answer|
	  	if answer[0].include?("question(#{self.id})")
	  		return [answer[1]]
	  	end
  	end
  end

end

class FlatAnswer < Question

  def get_header
  	# Must return as array to use concat
  	return [underscore(self.title)]
  end

  def get_answer
  	# Must return as array to use concat
  	answer_string = ''
  	self.answer_set.each do |answer|
	  	if answer[0].include?("question(#{self.id})")
	  		answer_string << answer[1] + ' '
	  	end
  	end
  	return [answer_string]
  end

end

class MultiAnswer < Question

  def get_header
		title_array = []
  	self.options.each do |option|
  		title_array << underscore(self.title + '_' + option['title']['English'])
  	end
  	return title_array
  end

  def get_answer
  	answer_array = []
  	self.answer_set.each do |answer|
	  	if answer[0].include?("question(#{self.id})")
	  		answer_array << answer[1]
	  	end
  	end
  	return answer_array
  end

end

class ParseTask

	require 'json'
	require 'csv'

	def self.parse_survey_questions(q_json_string)
		questions_array = []
		q_json_data = JSON.parse(q_json_string)
	  q_json_data.each do |question|
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

	def self.parse_survey_responses(questions_array, r_json_string)

		responses_array = []
		questions_info = []

  	questions_array.each do |question|
  		if question.options != nil
  	    questions_info_hash =  {id: question.id, type: question.class, options_count: question.options.count}
  	  else
  	  	questions_info_hash =  {id: question.id, type: question.class}
  	  end
  	  questions_info << questions_info_hash
  	end
		
	  r_json_data = JSON.parse(r_json_string)
	  r_json_data.each_with_index do |response, i|
	  	responses_array[i] = []
	  	questions_info.each do |q_info|
	  		# Set the type of the new object according to the one in the questions array
	  		answer_for_push = q_info[:type].new(id: q_info[:id], answer_set: [])
					  	
		  	answers_set = response.group_by {|i| i[0].include?("[question(#{q_info[:id]})")}
		  	if answers_set[true] == nil
		  		answers_set[true] = []
		  		answers_set[true] << ["[question(#{q_info[:id]})]", ''] 
		  	end
		  	if q_info[:options_count]
		  		while answers_set[true].count < q_info[:options_count]
		  			answers_set[true] << ["[question(#{q_info[:id]})]", '']
		  		end
		  	end
		  	answer_for_push.answer_set = answers_set[true]
		  	# TODO Remove
		  	puts "Adding answers for response #{i + 1}, question #{q_info[:id]}."
		  	
		  	responses_array[i] << answer_for_push
		  end
	  end

	  return responses_array
		
	end

	def self.parseCSV(survey)

		parsed_csv = CSV.generate do |csv|
			questions_array = parse_survey_questions(survey.questions_json)
			responses_array = parse_survey_responses(questions_array, survey.responses_json)

			header_row = []
			questions_array.each do |question|
				header_row.concat(question.get_header)
			end
			csv << header_row
			
			responses_array.each do |response|
				response_row = []
				response.each do |answer_object|
					response_row.concat(answer_object.get_answer)
				end
				csv << response_row
			end
		
		end
		survey.update_attributes(csv: parsed_csv)
	end
	


end



