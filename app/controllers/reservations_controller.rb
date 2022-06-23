class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @reservations = current_user.reservations
  end

  def create
    room = Room.find(params[:room_id])

    @reservation = Reservation.new(
      datetime: datetime,
      price: room.price,
      user_id: current_user.id,
      room_id: room.id,
    )

    if @reservation.save_and_notify
      flash[:notice] = "Request sent successfully!"
    else
      flash[:alert] = @reservation.errors.full_messages.first
    end

    redirect_to room
  end

  private

  def datetime
    date_array = Date.parse(reservation_params[:datetime]).to_s.split("-")
    time_array = reservation_params[:time].split(":")

    Time.new(*(date_array + time_array))
  end

  def reservation_params
    params.require(:reservation).permit(:datetime, :time)
  end
end
