class SurveysController < ApplicationController
  def index
  	@surveys = Survey.all
  end

  def show
  	@survey = Survey.find(params[:id])
  end

  def new
  	@survey = Survey.new
  end

  def create
  	if @survey = Survey.find_by_sg_id(params[:survey][:sg_id])
      @survey.destroy
  		# if @survey.update_attributes(params[:survey])
  		# 	flash[:success] = 'Survey found and loaded.'
  		# 	redirect_to survey_path(@survey)
  		# else
  		# 	flash[:error] = 'Cound not find a survey with that ID.'
  		# 	render 'new'
  		# end
  	end
		@survey = Survey.new(params[:survey])
		if @survey.save
			flash[:success] = 'Survey found and loaded.'
			redirect_to survey_path(@survey)
		else
			flash[:error] = 'Cound not find a survey with that ID.'
			render 'new'
		end
  end

  def parse
    survey = Survey.find(params[:id])
    survey.delay.parseCSV
    respond_to do |format|
      format.js
    end
  end

  def download
    survey = Survey.find(params[:id])
    csv = survey.csv
    respond_to do |format|
      format.csv { send_data csv }
    end
  end

end
