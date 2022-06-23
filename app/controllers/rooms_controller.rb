class RoomsController < ApplicationController
  before_action :set_room

  def show
    redirect_to root_path unless user_can_view_room

    @room = RoomWithAvailability.new(
      room: @room,
      date: params[:date].presence || Date.today,
    )
  end

  def availability
    room = RoomWithAvailability.new(
      room: @room,
      date: Date.parse(params[:date]),
    )

    render json: room.available_reservation_times
  end

  private

  def user_can_view_room
    @room.active? || current_user&.id == @room.user_id
  end

  def set_room
    @room = Room.find(params[:id])
  end
end
