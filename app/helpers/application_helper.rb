module ApplicationHelper

  def current_user
    @user
  end

  def section?(section)
    @section == section
  end

end
