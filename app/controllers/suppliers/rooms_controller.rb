module Suppliers
  class RoomsController < SuppliersController
    skip_before_action :authorize_supplier, only: %i[new create]

    before_action :set_room, except: %i[index new create]
    before_action :authorize_user!, except: %i[index new create]

    def index
      @rooms = current_user.rooms
    end

    def new
      @room = current_user.rooms.build
    end

    def create
      @room = current_user.rooms.build(room_params)

      if @room.save
        redirect_to open_hours_suppliers_room_path(@room), notice: "Saved..."
      else
        flash[:alert] = @room.errors.full_messages.first

        render :new
      end
    end

    def update
      if @room.update(room_params)
        flash[:notice] = "Saved..."
      else
        flash[:alert] = @room.errors.full_messages.first
      end

      redirect_back(fallback_location: root_path)
    end

    def description; end

    def amenities; end

    def pricing; end

    def location; end

    def open_hours; end

    def photo_upload; end

    private

    def set_room
      @room = Room.find(params[:id])
    end

    def authorize_user!
      if current_user.id != @room.user_id
        redirect_to root_path, alert: "You don't have permission"
      end
    end

    def room_params
      params.
        require(:room).
        permit(
          :name, :address, :summary, :stations, :price, :active,
          :available_procedures, :open_hours, :practitioners, :has_lobby,
          :has_xrays, :has_heating, :has_internet, :appointment_duration,
          payment_methods: [], open_hours_week_days: [],
          open_hours_special_days: []
        )
    end
  end
end
