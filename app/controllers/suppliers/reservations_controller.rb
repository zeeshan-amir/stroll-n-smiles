module Suppliers
  class ReservationsController < SuppliersController
    before_action :set_reservation, except: :index

    def index
      @reservations = current_user.rooms_reservations
    end

    def approve
      @reservation.approved!

      NotifyReservationApproval.call(@reservation)
      flash[:notice] = "Reservation created successfully!"

      redirect_to suppliers_reservations_path
    end

    def decline
      @reservation.declined!

      redirect_to suppliers_reservations_path
    end

    private

    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
  end
end
