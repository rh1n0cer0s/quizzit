class WelcomeController < ApplicationController
  def index
    redirect_to quizzes_path if User.current
  end
end
