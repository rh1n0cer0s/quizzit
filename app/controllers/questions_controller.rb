class QuestionsController < ApplicationController
  before_filter :require_login
  before_filter :find_quiz
  before_filter :require_teacher, :only => [:new, :edit, :update, :create]

  def index
    @questions = Question.scoped
  end

  def new
    @question = @quiz.questions.build
    @question.answers.build
  end

  def create
    attributes = params[:question].dup
    attributes[:answers_attributes] = attributes[:answers_attributes].reject{|a| !a || !a[:title] || a[:title].empty?}

    @question = Question.new(attributes)

    if @question.save
      redirect_to quiz_path(:id => @quiz), notice: 'Created a question!'
    else
      render action: "new"
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])

    attributes = params[:question].dup
    attributes[:answers_attributes] = attributes[:answers_attributes].reject{|a| !a || !a[:title] || a[:title].empty?}
    if @question.update_attributes(attributes)
      redirect_to quiz_path(:id => @quiz), notice: 'Updated!'
    else
      render action: "edit"
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    redirect_to quiz_path(@quiz), notice: "Question deleted"
  end

  private

  def find_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end
end
