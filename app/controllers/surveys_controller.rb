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
  	if @survey = Survey.find_by_id(params[:survey][:sg_id])
  		if @survey.update_attributes(params[:survey])
  			flash[:success] = 'Survey found and loaded.'
  			redirect_to survey_path(@survey)
  		else
  			flash[:error] = 'Cound not find a survey with that ID.'
  			render 'new'
  		end
  	else 
  		@survey = Survey.new(params[:survey])
  		if @survey.save
  			flash[:success] = 'Survey found and loaded.'
  			redirect_to survey_path(@survey)
  		else
  			flash[:error] = 'Cound not find a survey with that ID.'
  			render 'new'
  		end
  	end
  end


end
