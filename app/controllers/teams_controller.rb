class TeamsController < ApplicationController
  before_filter :require_login
  before_filter :require_leader

  def new
    @team = User.current.build_team
    @team.users.build
    @team.users.build
  end
end
