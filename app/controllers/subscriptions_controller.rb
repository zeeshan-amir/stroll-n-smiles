class SubscriptionsController < ApplicationController
  def index
    @plans = Plan.by_id
    @subscription = Subscription.new
  end

  def new
    @plans = Plan.by_id
    @subscription = Subscription.new
    @selected = params[:plan]
  end

  def create
    @subscription = Subscription.new(subscription_params)

    if @subscription.valid?
      ReservationMailer.new_customer(@subscription).deliver

      flash[:success] = "Thank you, an agent will contact you shortly"
    end
  end

  private
  def subscription_params
    params.require(:subscription).permit(:name, :email, :plan, :message)
  end
end
