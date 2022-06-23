require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AirPikachu
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Load local variables
    env_file = Rails.root.join("config", "local_env.yml")

    if File.exists?(env_file)
      YAML.safe_load(File.open(env_file)).each do |key, value|
        ENV[key.to_s] = value
      end
    end

    config.load_defaults 6.0

    config.time_zone = "America/Guayaquil"
    config.active_record.default_timezone = :local
    config.active_record.time_zone_aware_attributes = false

    config.raise_on_unfiltered_parameters = true
    config.ssl_options = { hsts: { subdomains: true } }
    config.action_controller.per_form_csrf_tokens = true
    config.action_view.form_with_generates_remote_forms = false
    config.active_record.cache_versioning = true
    config.active_record.belongs_to_required_by_default = true

    # Mailer configuration
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      user_name: "apikey",
      password: ENV["SENDGRID_API_KEY"],
      domain: "tuvidaenorden.com",
      address: "smtp.sendgrid.net",
      port: 587,
      authentication: :plain,
      enable_starttls_auto: true,
    }

    # Custom error pages
    config.exceptions_app = self.routes
  end
end
