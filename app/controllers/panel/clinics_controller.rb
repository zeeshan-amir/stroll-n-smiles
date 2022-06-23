class Panel::ClinicsController < PanelController
  def index
    @user = User.find(params[:user_id])
  end

  def update
    @room = Room.find(params[:id])

    if @room.update(clinic_params)
      render json: { status: 200 }
    else
      render json: { error: @room.errors.full_messages.first }
    end
  end

  private

  def clinic_params
    params.
      require(:clinic).
      permit(:approved, :active, :featured, :search_priority, :featured_order)
  end
end
