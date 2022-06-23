class RegistrationsController < Devise::RegistrationsController
  def create
    if verify_recaptcha(action: "create")
      super
    else
      Rails.logger.warn("reCaptcha failed: #{recaptcha_error_message}")

      recaptcha_response
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def recaptcha_response
    self.resource = resource_class.new sign_up_params
    resource.validate
    resource.errors.add(:base, flash[:recaptcha_error])

    respond_with_navigational(resource) { render :new }
  end

  def recaptcha_error_message
    score = recaptcha_reply["score"]
    codes = recaptcha_reply["error-codes"]

    if    score.present? then "low score (#{score})"
    elsif codes.present? then codes.join(", ")
    else "unkown error"
    end
  end
end
