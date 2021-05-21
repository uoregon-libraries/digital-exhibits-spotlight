# frozen_string_literal: true

module UploadHelper
  include QueryUploads

  def format_max_total(exhibit_id)
    bytes = upload_total(exhibit_id)
    bytes == 0 ? 0 : "less than #{ (bytes/1000000) + 1 }"
  end

  def format_max_bytes
    Rails.configuration.max_upload_total_bytes/1000000
  end
end
