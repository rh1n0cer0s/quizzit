class QuizzesController < ApplicationController
  before_filter :require_login
  before_filter :require_leader, :except => [:index, :take]

  def index
    if User.current && User.current.leader? && !User.current.team
      redirect_to new_team_path
    else
      @quizzes = Quiz.scoped
    end
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

  def show
    @quiz = Quiz.find(params[:id])
  end

  def edit
    @quiz = Quiz.find(params[:id])
  end

  def update
    @quiz = Quiz.find(params[:id])

    if @quiz.update_attributes(params[:quiz])
      redirect_to @quiz, notice: 'Updated!'
    else
      render action: "edit"
    end
  end

  def destroy
    @quiz = Quiz.find(params[:id])
    @quiz.destroy

    redirect_to quizzes_path
  end

  def take
    @quiz = Quiz.find params[:id]
    @result = Result.find_by_user_id_and_quiz_id(User.current, @quiz)

    unless @result
      @result = Result.new
      @result.quiz = @quiz
      @result.user = User.current
      @result.details = {}
      @result.save
    end

    if request.get?
      @question = @result.unanswered_questions.first
    else
      @question = @quiz.questions.find(params[:question_id])
      question_result = @question.correct?(params[:answers])
      @result.answer_question! @question, question_result
      render :json => {:result => question_result}
    end
  end
end
