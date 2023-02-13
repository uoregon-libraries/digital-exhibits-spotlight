require_relative 'boot'

require 'rails/all'
require_relative 'initializers/carrierwave_option'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpotlightDemo
  class Application < Rails::Application
          config.action_mailer.default_url_options = { host: ENV["URL_HOST"], from: ENV["MAIL_SENDER"] }
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    #fix for Psych::DisallowedClassError
    config.active_record.yaml_column_permitted_classes = [
      ActiveSupport::HashWithIndifferentAccess,
      ActiveSupport::TimeWithZone,
      ActiveSupport::TimeZone,
      Date,
      Symbol,
      Time
    ]
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.action_dispatch.default_headers = {
      'Referrer-Policy' => 'strict-origin-when-cross-origin',
      'X-Content-Type-Options' => 'nosniff'
    }

    config.to_prepare do
      Spotlight::Resources::UploadController.prepend(UploadControllerBehavior)
      Spotlight::FeaturedImageUploader.prepend(CarrierWaveOption)
    end
  end
end
