source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.6.6"

gem "active_storage_validations"
gem "aws-sdk-s3", require: false
gem "bootstrap-sass", "~> 3.3"
gem "chartkick", "~> 2.2"
gem "coffee-rails", "~> 5.0"
gem "devise", "~> 4.2"
gem "fullcalendar-rails", "~> 3.4"
gem "geocoder", "~> 1.4"
gem "jbuilder", "~> 2.10"
gem "jquery-rails"
gem "jquery-ui-rails", "~> 5.0"
gem "mini_magick"
gem "minitest", "~> 5.10"
gem "momentjs-rails", "~> 2.17"
gem "omniauth", "~> 1.6"
gem "omniauth-facebook", "~> 4.0"
gem "pg", "~> 0.20"
gem "puma", "~> 4.3"
gem "rails", "~> 6.0"
gem "ransack", "~> 2.0"
gem "recaptcha"
gem "sass-rails", "~> 5.0"
gem "sendgrid-ruby"
gem "toastr-rails", "~> 1.0"
gem "turbolinks", "~> 5"
gem "twilio-ruby", "~> 4.11"
gem "uglifier", ">= 1.3"

gem "rails-assets-card", source: "https://rails-assets.org"

group :development do
  gem "listen", "~> 3.0"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", ">= 3.3"
end

group :development, :test do
  gem "byebug", platform: :mri
  gem "factory_bot_rails"
end

group :test do
  gem "rails-controller-testing"
  gem "shoulda", "4.0.0.rc2"
end

group :production do
  gem "redis", "~> 3.3"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
