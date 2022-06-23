class CurrentUserController < ApplicationController
  before_action :authenticate_user!

  def update_phone_number
    current_user.update(phone_number: params[:user][:phone_number])
    current_user.generate_pin
    current_user.send_pin

    redirect_to edit_user_registration_path, notice: "Saved..."
  rescue StandardError => e
    redirect_to edit_user_registration_path, alert: e.message.to_s
  end

  def verify_phone_number
    current_user.verify_pin(params[:user][:pin])

    if current_user.phone_verified
      flash[:notice] = "Your phone number is verified."
    else
      flash[:alert] = "Cannot verify your phone number."
    end

    redirect_to edit_user_registration_path
  rescue StandardError => e
    redirect_to edit_user_registration_path, alert: e.message.to_s
  end
end
