class Response < ActiveRecord::Base
  belongs_to :survey

  attr_accessible :json_response, :sg_response_id, :survey_id

  validates :survey_id, :sg_response_id, :json_response, presence: true

end
