class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :session_expiration, :user_setup

  def session_expiration
    if session[:user_id]
      if session_expired? 
        reset_session
        flash[:error] = l(:error_session_expired)
        redirect_to signin_url
      else
        session[:atime] = Time.now.utc.to_i
      end
    end
  end

  def session_expired?
    false
  end

  def start_user_session(user)
    session[:user_id] = user.id
    session[:ctime] = Time.now.utc.to_i
    session[:atime] = Time.now.utc.to_i
  end

  def user_setup
    # Find the current user
    User.current = find_current_user
  end

  def find_current_user
    if session[:user_id]
      (User.find(session[:user_id]) rescue nil)
    end
  end

  def logged_user=(user)
    reset_session
    if user && user.is_a?(User)
      User.current = user
      start_user_session(user)
    else
      User.current = nil
    end
  end

  def logout_user
    if User.current
      self.logged_user = nil
    end
  end

  def redirect_back_or_default(default)
    back_url = CGI.unescape(params[:back_url].to_s)
    if !back_url.blank?
      begin
        uri = URI.parse(back_url)
        # do not redirect user to another host or to the login or register page
        if (uri.relative? || (uri.host == request.host)) && !uri.path.match(%r{/(login|account/register)})
          redirect_to(back_url)
          return
        end
      rescue URI::InvalidURIError
        # redirect to default
      end
    end
    redirect_to default
    false
  end

  def require_logged_in
    require_login unless User.current
  end

  def require_login
    if !User.current
      if request.get?
        url = url_for(params)
      else
        url = url_for(:controller => params[:controller], :action => params[:action], :id => params[:id], :project_id => params[:project_id])
      end
      respond_to do |format|
        format.html { redirect_to :controller => "/account", :action => "login", :back_url => url }
      end
      return false
    end
    true
  end


  def require_logout
    if User.current 
      respond_to do |format|
        format.html { redirect_to :controller => "quizzes", :action => "index" }
      end
      return false
    end
  end

  def require_teacher
    User.current && User.current.teacher?
  end

  def render_403(options={})
    render_error({:message => :notice_not_authorized, :status => 403}.merge(options))
    return false
  end

  def render_404(options={})
    render_error({:status => 404}.merge(options))
    return false
  end

  protected

end
