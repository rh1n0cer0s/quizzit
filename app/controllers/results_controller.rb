class ResultsController < ApplicationController
  before_filter :require_login
  before_filter :find_quiz
  before_filter :require_teacher

  def show
    @result = Result.find(params[:id])
  end

  private

  def find_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end
