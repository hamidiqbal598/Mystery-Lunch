module ApplicationHelper

  def logout_path
    destroy_admin_session_path
  end

end
