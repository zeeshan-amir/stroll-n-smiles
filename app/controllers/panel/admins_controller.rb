class Panel::AdminsController < PanelController
  def index
    @admins = Admin.all
  end

  def new
    @admin = Admin.new
  end

  def create
    email = params[:admin][:email]
    password = Devise.friendly_token.first(8)

    @admin = Admin.new(email: email, password: password)

    if @admin.save
      flash[:success] = "Usuario <strong>#{@admin.email}</strong> creado exitosamente."
      PanelMailer.welcome(@admin.email, password).deliver_later
    end
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])

    if @admin.update(admin_params)
      flash[:success] = "Contraseña actualizada exitosamente."
    end

    render :create
  end

  def destroy
    admin = Admin.find(params[:id])
    admin.destroy

    redirect_to action: "index"
  end

  private
  def admin_params
    params.require(:admin).permit(:password, :password_confirmation)
  end
end
