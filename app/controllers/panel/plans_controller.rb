class Panel::PlansController < PanelController
  def index
    @plans = Plan.all.order(id: :ASC)
  end

  def edit
    @plan = Plan.find(params[:id])
  end


  def update
    @plan = Plan.find(params[:id])

    if @plan.update(plan_params)
      flash[:success] = "Plan actualizado exitosamente."
    end
  end

  private
  def plan_params
    params.require(:plan)
          .permit(:name, :price_monthly, :price_semiannual, :price_annual)
  end
end
