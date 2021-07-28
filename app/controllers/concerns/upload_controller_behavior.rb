# frozen_string_literal: true

module UploadControllerBehavior
  include QueryUploads
  def build_resource
    if upload_total(current_exhibit.id) >= Rails.configuration.max_upload_total_bytes
      respond(I18n.t('upload_max_error'))
    else
      super
    end
  rescue CarrierWave::IntegrityError => e
    respond(e.message)
  rescue CarrierWave::ProcessingError => e
    respond(e.message)
  end

  def respond(message)
    flash[:error] = message
    redirect_back(fallback_location: spotlight.exhibit_resources_path(current_exhibit))
  end
end
