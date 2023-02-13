class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Spotlight::Controller

  #layout 'blacklight'
  layout :determine_layout if respond_to? :layout

  protect_from_forgery with: :exception
end
