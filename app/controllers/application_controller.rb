class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Spotlight::Controller
  skip_after_action :discard_flash_if_xhr
  layout 'blacklight'

  protect_from_forgery with: :exception
end
