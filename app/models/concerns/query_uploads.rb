# frozen_string_literal: true

module QueryUploads
  def upload_total(exhibit_id)
    Spotlight::Resource.where(
      'type=? AND exhibit_id=?', 'Spotlight::Resources::Upload', exhibit_id
    ).limit(100).map { |x| size(x) }.reduce(0, :+)
  end

  def size(resource)
    resource.upload.image.size
  rescue StandardError
    0
  end
end
