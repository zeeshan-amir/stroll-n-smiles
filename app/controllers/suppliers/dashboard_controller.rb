module Suppliers
  class DashboardController < SuppliersController
    def index
      @rooms = current_user.rooms
    end
  end
end
