require 'spec_helper'

describe Question do
	describe 'underscore' do
	  it 'should return a word without special characters' do
	    question = Question.new(id: 1, title: 'One small step?')
	    question.underscore(question.title).should eq 'one_small_step'
	  end
	end

end

describe SingleAnswer do
	describe 'get_header' do
		it 'should return a word without special characters' do
		  single_answer = SingleAnswer.new(id: 1, title: 'One small step?')
		  single_answer.get_header.should eq 'one_small_step'
		end
	end

	describe 'get_answer' do
		it 'should return the answer' do
		  single_answer = SingleAnswer.new(id: 1, answer_set: [['[question(1)]', 'Yes!']])
	    single_answer.get_answer.should eq 'Yes!'
		end
	end
end

describe FlatAnswer do
	describe 'get_header' do
		it 'should return a word without special characters' do
		  flat_answer = FlatAnswer.new(id: 1, title: 'One small step?')
		  flat_answer.get_header.should eq 'one_small_step'
		end
	end

	describe 'get_answer' do
		it 'should return the answer array' do
		  flat_answer = FlatAnswer.new(id: 1, answer_set: [['[question(1), option(10022)', 'Yes'],['[question(1), option(10023)]', 'No']])
	    flat_answer.get_answer.should eq 'Yes No '
		end
	end
end

describe MultiAnswer do
	describe 'get_header' do
		it 'should return an array without special characters' do
		  multi_answer = MultiAnswer.new(id: 1, title: 'One step?',
		  options: [{'title' => {'English' => 'I say?'}}, {'title' => {'English' => '!I do say??'}}])
		  multi_answer.get_header.should eq ['one_step_i_say','one_step_i_do_say']
    end
	end

	describe 'get_answer' do
		it 'should return the answer array' do
		  multi_answer = MultiAnswer.new(id: 1, answer_set: [['[question(1), option(10022)', 'Yes'],['[question(1), option(10023)]', 'No']])
	    multi_answer.get_answer.should eq ['Yes', 'No']
		end
	end
end

describe ParseTask do
	describe 'parse_survey_questions_responses' do

		before(:each) do
		  @q_json_string = '['
			@q_json_string +=  '{"id":1,"_subtype":"checkbox","title":{"English":"Question - Checkbox"},"options":['
			@q_json_string +=    	'{"id":10010,"value":"One"},{"id":10011,"value":"Two"},{"id":10012,"value":"Three"}'
			@q_json_string +=   ']},'
			@q_json_string += 	'{"id":2,"_subtype":"textbox","title":{"English":"Question - String"}}'
			@q_json_string += ']'
		end

		it 'should parse the question headers' do
		  q_array = ParseTask.parse_survey_questions(@q_json_string)
		  puts q_array
		  q_array[0].class.should eq FlatAnswer
		  q_array[0].id.should eq 1
		  q_array[0].title.should eq 'Question - Checkbox'
		  q_array[1].class.should eq SingleAnswer
		  q_array[1].id.should eq 2
		  q_array[1].title.should eq 'Question - String'
		end

		it 'should parse the question responses' do
		  r_json_string = '['
		  r_json_string +=   '{"id":"1","[question(1), option(10013)]":"One","[question(1), option(10014)]":"Two", "[question(2)]":"Test one"},'
		  r_json_string += 	 '{"id":"2","[question(1), option(10013)]":"One","[question(2)]":"Test two"}'
		  r_json_string += ']'
		  q_array = ParseTask.parse_survey_questions(@q_json_string)
		  response_item = JSON.parse(r_json_string).first
		  ParseTask.stringify_responses(q_array, response_item).should eq ['One Two  ', 'Test one']
		end
	end

end