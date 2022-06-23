class PanelController < ActionController::Base
  layout 'panel'

  protect_from_forgery with: :exception
  before_action :authenticate_admin!
  helper_method :current_admin

  def current_admin
    @current_admin ||= Admin.find(session[:admin_id]) if session[:admin_id]
  end

  def authenticate_admin!
    redirect_to panel_login_path if current_admin.nil?
  end
end
