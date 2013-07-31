class QuizzesController < ApplicationController
  before_filter :require_login
  before_filter :require_teacher, :only => [:new, :edit, :update, :create]

  def index
    @quizzes = Quiz.scoped
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(params[:quiz])

    if @quiz.save
      redirect_to @quiz, notice: 'Created a quiz!'
    else
      render action: "new"
    end
  end
end
