class Survey < ActiveRecord::Base

  require 'csv'

  attr_accessible :status, :survey_created, :sg_id, :title, :questions_json, :responses_json, :response_count, :csv, :downloaded_at

  validates  :survey_created, :sg_id, :questions_json, :responses_json, :response_count, presence: true
  validates :title, :status, presence: true, length: { maximum: 80 }

  before_validation :obtain_sg_details, on: :create

  def parseCSV

    parsed_csv = CSV.generate do |csv|
      questions_array = ParseTask.parse_survey_questions(self.questions_json)
      csv << ParseTask.stringify_survey_questions_responses(questions_array, self.responses_json)
    end

    self.csv = nil
    self.csv = parsed_csv
    self.downloaded_at = Time.now
    self.save!
  end

  private

  def obtain_sg_details
  	survey_json = JSON.parse(SgApi.get_sg_survey(self.sg_id))
  	if survey_json != nil && survey_json['result_ok'] != false
	  	self.title = survey_json['data']['title']
	  	self.survey_created = survey_json['data']['created_on']
	  	self.status = survey_json['data']['status']

      json_q = JSON.parse(SgApi.get_sg_survey_questions(self.sg_id))
	  	self.questions_json = JSON.dump(json_q['data'])

      json_r = JSON.parse(SgApi.get_sg_survey_responses(self.sg_id, ''))
      json_r_s = json_r['data']

      if json_r['page'] < json_r['total_pages']
        next_page = json_r['page'] + 1
        json_r_next = JSON.parse(SgApi.get_sg_survey_responses(self.sg_id, 'page=' + next_page.to_s + '&'))
        json_r_next['data'].each do |response_item|
          json_r_s << response_item
        end
      end
      self.responses_json = JSON.dump(json_r_s)

      self.response_count = json_r['total_count'].to_i

	  end
  end

end
