module OpenHours
  class WeekDaysController < ApplicationController
    def create
      @open_hours = OpenHours::WeekDay.new(week_days_params)

      if @open_hours.save
        render_success
      else
        render_error
      end
    end

    def update
      @open_hours = OpenHours::WeekDay.find(params[:id])

      if @open_hours.update(week_days_params)
        render_success
      else
        render_error
      end
    end

    def destroy
      open_hours = OpenHours::WeekDay.find(params[:id])
      room = open_hours.room

      open_hours.destroy

      render json: {
        ready: room.ready?,
        open_hours: room.open_hours_week_days.present?,
      }
    end

    private

    def week_days_params
      params.permit(:week_day, :open, :close, :room_id)
    end

    def render_success
      render json: { id: @open_hours.id, room_ready: @open_hours.room.ready? },
             status: :ok
    end

    def render_error
      render json: { message: @open_hours.errors.full_messages.first },
             status: :unprocessable_entity
    end
  end
end
