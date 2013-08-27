class AccountController < ApplicationController
  before_filter :require_logout, :except => :logout

  def login
    @user = User.new
    if request.get?
      logout_user
    else
      @user.email = params[:user][:email]
      @user.password = params[:user][:password]
      authenticate_user
    end
  end

  def logout
    logout_user
    redirect_to root_path
  end

  def signup
    if request.get?
      @user = User.new
      @user.kind = :leader
    else
      @user = User.new
      @user.kind = :leader
      @user.email = params[:user][:email]
      @user.password, @user.password_confirmation = params[:user][:password], params[:user][:password_confirmation]
      if @user.save
        redirect_to quizzes_path
      end
    end
  end

  private

  def authenticate_user
    password_authentication
  end

  def password_authentication
    user = User.try_to_login(@user.email, @user.password)

    if user.nil?
      invalid_credentials
    else
      successful_authentication(user)
    end
  end

  def successful_authentication(user)
    self.logged_user = user
    redirect_back_or_default quizzes_path
  end

  def invalid_credentials
    logger.warn "Failed login for '#{@user.email}' from #{request.remote_ip} at #{Time.now.utc}"
    flash.now[:error] = "Invalid credentials"
  end
end

