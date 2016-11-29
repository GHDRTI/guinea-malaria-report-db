class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl if: :use_ssl?
  
  before_filter :require_user

  def require_user
    unless load_user
      redirect_to controller: 'login'
    end
  end

  def load_user
    @key = request.cookies['login_magic_key']
    @user = User.user_by_login_key @key
    return @user
  end
  
  def current_user
    @user
  end

  def section section
    @section = section
  end

  def use_ssl?
    ENV['RAILS_ENV'] != 'development' 
  end

end
