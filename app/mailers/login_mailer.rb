class LoginMailer < ActionMailer::Base
  add_template_helper(ApplicationHelper)

  def magic_link(user)
    @user = user
    @login_link = url_for host: MagicLink[:host], controller: 'login', 
      action: 'login', key: user.login_key
    mail(to: @user.email, from: MagicLink[:from], subject: 'Stop Palu Database log in')
  end

end