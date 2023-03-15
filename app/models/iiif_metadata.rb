# frozen_string_literal: true

###
#  A simple class to map the metadata field
#  in a IIIF document to label/value pairs
#  This is intended to be overriden by an
#  application if a different metadata
#  strucure is used by the consumer
class IiifMetadata < Spotlight::Resources::IiifManifest::Metadata

  def html_sanitize(value)
    return value if oregondigital?

    super
  end

  def oregondigital?
    URI(@manifest['@id']).host.include? 'oregondigital.org'
  end
end
