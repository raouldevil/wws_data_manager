class SurveysController < ApplicationController
  def index
  	@surveys = Survey.all
  end

  def show
  	@survey = Survey.find(params[:id])
  	@responses = @survey.responses
  end
end
