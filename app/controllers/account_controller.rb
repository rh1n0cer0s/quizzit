class AccountController < ApplicationController
  before_filter :require_logout, :except => :logout

  def login
    if request.get?
      logout_user
    else
      authenticate_user
    end
  end

  def logout
    logout_user
    redirect_to root_path
  end

  private

  def authenticate_user
    password_authentication
  end

  def password_authentication
    user = User.try_to_login(params[:login], params[:password], params[:kind])

    if user.nil?
      invalid_credentials
    else
      successful_authentication(user)
    end
  end

  def successful_authentication(user)
    self.logged_user = user
    redirect_back_or_default user.kind == :teacher ? "/" : "/"
  end

  def invalid_credentials
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
    flash.now[:error] = "Invalid credentials"
  end
end

