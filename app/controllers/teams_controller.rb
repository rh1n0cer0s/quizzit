class TeamsController < ApplicationController
  before_filter :require_login
  before_filter :require_leader

  def new
    @team = User.current.build_team
    2.times { @team.members.build }
  end

  def create
    @team = User.current.build_team
    @team.attributes = params[:team]
    @team.members.each {|m| m.team = @team }

    if @team.save
      User.current.team = @team
      User.current.save
      redirect_to quizzes_path, notice: 'Created a quiz!'
    else
      puts @team.errors.to_yaml
      render action: "new"
    end
  end
end
