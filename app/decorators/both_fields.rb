# frozen_string_literal: true

# Want both tesim and ssim on readonly fields on incoming iiif resources
# more shameless copying from dpul
class BothFields < SimpleDelegator
  def alternate_field
    field.gsub(/(.*)_.*$/, '\1' + alternate_field_suffix)
  end

  private

    def alternate_field_suffix
      if field.ends_with?(Spotlight::Engine.config.solr_fields.string_suffix)
        Spotlight::Engine.config.solr_fields.text_suffix
      else
        Spotlight::Engine.config.solr_fields.string_suffix
      end
    end
end


