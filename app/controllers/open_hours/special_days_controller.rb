module OpenHours
  class SpecialDaysController < ApplicationController
    def create
      @open_hours = OpenHours::SpecialDay.new(special_days_params)

      if @open_hours.save
        render_success
      else
        render_error
      end
    end

    def update
      @open_hours = OpenHours::SpecialDay.find(params[:id])

      if @open_hours.update(special_days_params)
        render_success
      else
        render_error
      end
    end

    def destroy
      OpenHours::SpecialDay.find(params[:id]).destroy

      head :no_content
    end

    private

    def special_days_params
      params.permit(:day, :month, :open, :close, :room_id)
    end

    def render_success
      render json: { id: @open_hours.id }, status: :ok
    end

    def render_error
      render json: { message: @open_hours.errors.full_messages.first },
             status: :unprocessable_entity
    end
  end
end
