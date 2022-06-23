class Panel::SessionsController < PanelController
  skip_before_action :authenticate_admin!

  def new
    @admin = Admin.new
  end

  def create
    admin = Admin.find_by(email: params[:admin][:email].downcase)

    if admin && admin.authenticate(params[:admin][:password])
      session[:admin_id] = admin.id.to_s

      redirect_to panel_root_path
    else
      flash.now[:error] = "Invalid e-mail or password."
      render :new
    end
  end

  def destroy
    session.delete(:admin_id)

    redirect_to panel_login_path
  end
end
