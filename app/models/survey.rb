# class Survey < ActiveRecord::Base
# 	has_many :responses, :foreign_key => :sg_id

#   attr_accessible :status, :survey_created, :survey_id, :title

#   validates  :survey_created, :sg_id, presence: true
#   validates :title, :status, presence: true, length: { maximum: 80 }
# end
