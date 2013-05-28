class Survey < ActiveRecord::Base


  attr_accessible :status, :survey_created, :sg_id, :title, :questions_json, :responses_json

  validates  :survey_created, :sg_id, :questions_json, :responses_json, presence: true
  validates :title, :status, presence: true, length: { maximum: 80 }

  before_validation :obtain_sg_details

  private

  def obtain_sg_details
  	survey_json = JSON.parse(SgApi.get_sg_survey(self.sg_id))
  	if survey_json != nil && survey_json['result_ok'] != false
	  	self.title = survey_json['data']['title']
	  	self.survey_created = survey_json['data']['created_on']
	  	self.status = survey_json['data']['status']
	  	self.questions_json = SgApi.get_sg_survey_questions(self.sg_id)
	  	self.responses_json = SgApi.get_sg_survey_responses(self.sg_id)
	  end
  end

end
