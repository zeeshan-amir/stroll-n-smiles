class Panel::UsersController < PanelController
  def index
    @users = User.all
  end
end
