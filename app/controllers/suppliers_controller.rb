class SuppliersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_supplier

  private

  def authorize_supplier
    redirect_to root_path unless current_user.supplier?
  end
end
