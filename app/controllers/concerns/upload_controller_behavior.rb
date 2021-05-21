# frozen_string_literal: true

module UploadControllerBehavior
  def build_resource
    if upload_total >= Rails.configuration.max_upload_total_bytes
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

  def upload_total
    Spotlight::Resource.where(
      'type=? AND exhibit_id=?', 'Spotlight::Resources::Upload', current_exhibit.id
    ).limit(100).map { |x| size(x) }.reduce(0, :+)
  end

  def size(resource)
    resource.upload.image.size
  rescue StandardError
    0
  end
end
