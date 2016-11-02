class LoginController < ApplicationController

  layout 'login'

  skip_before_filter :require_user

  def index

  end

  def send_login
    @email = params[:email]
    user = User.where(email: @email).first
    if user
      user.new_login_key!
      LoginMailer.magic_link(user).deliver_now
    else
      @error = 'not_found'
      render action: 'index'
    end
  end

  def login
    cookies['login_magic_key'] = {
       :value => params[:key],
       :expires => 1.month.from_now
     }
    return redirect_to controller: 'home'
  end

  def logout
    cookies.delete 'login_magic_key'
    return redirect_to controller: 'login'
  end

end