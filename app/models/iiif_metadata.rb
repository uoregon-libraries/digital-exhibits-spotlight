class IiifMetadata
  def initialize(manifest)
    @manifest = manifest
  end

  def to_solr
    metadata_hash.merge(manifest_level_metadata)
  end

  def label
    return unless manifest.try(:label)

    Array(json_ld_value(manifest.label)).first
  end

  private

  attr_reader :manifest

  def metadata
    manifest.try(:metadata) || []
  end

  def metadata_hash
    return {} unless metadata.present?
    return {} unless metadata.is_a?(Array)

    metadata.each_with_object({}) do |md, hash|
      next unless md['label'] && md['value']

      label = Array(json_ld_value(md['label'])).first

      hash[label] ||= []
      hash[label] += Array(json_ld_value(md['value']))
    end
  end

  def manifest_level_metadata
    manifest_fields.each_with_object({}) do |field, hash|
      next unless manifest.respond_to?(field) &&
        manifest.send(field).present?

      hash[field.capitalize] ||= []
      hash[field.capitalize] += Array(json_ld_value(manifest.send(field)))
    end
  end

  def manifest_fields
    %w(attribution description license)
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
  def json_ld_value(value)
    case value
      # In the case where multiple values are supplied, clients must use the following algorithm to determine which values to display to the user.
    when Array
      # IIIF v2, multivalued monolingual, or multivalued multilingual values

      # If none of the values have a language associated with them, the client must display all of the values.
      if value.none? { |v| v.is_a?(Hash) && v.key?('@language') }
        value.map { |v| json_ld_value(v) }
        # If any of the values have a language associated with them, the client must display all of the values associated with the language that best
        # matches the language preference.
      elsif value.any? { |v| v.is_a?(Hash) && v['@language'] == default_json_ld_language }
        value.select { |v| v.is_a?(Hash) && v['@language'] == default_json_ld_language }.map { |v| v['@value'] }
        # If all of the values have a language associated with them, and none match the language preference, the client must select a language
        # and display all of the values associated with that language.
      elsif value.all? { |v| v.is_a?(Hash) && v.key?('@language') }
        selected_json_ld_language = value.find { |v| v.is_a?(Hash) && v.key?('@language') }

        value.select { |v| v.is_a?(Hash) && v['@language'] == selected_json_ld_language['@language'] }
          .map { |v| v['@value'] }
        # If some of the values have a language associated with them, but none match the language preference, the client must display all of the values
        # that do not have a language associated with them.
      else
        value.select { |v| !v.is_a?(Hash) || !v.key?('@language') }.map { |v| json_ld_value(v) }
      end
    when Hash
      # IIIF v2 single-valued value
      if value.key? '@value'
        value['@value']
        # IIIF v3 multilingual(?), multivalued(?) values
        # If all of the values are associated with the none key, the client must display all of those values.
      elsif value.keys == ['none']
        value['none']
        # If any of the values have a language associated with them, the client must display all of the values associated with the language
        # that best matches the language preference.
      elsif value.key? default_json_ld_language
        value[default_json_ld_language]
        # If some of the values have a language associated with them, but none match the language preference, the client must display all
        # of the values that do not have a language associated with them.
      elsif value.key? 'none'
        value['none']
        # If all of the values have a language associated with them, and none match the language preference, the client must select a
        # language and display all of the values associated with that language.
      else
        value.values.first
      end
    else
      # plain old string/number/boolean
      value
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity

  def html_sanitize(value)
    return value unless value.is_a? String

    html_sanitizer.sanitize(value)
  end

  def html_sanitizer
    @html_sanitizer ||= Rails::Html::FullSanitizer.new
  end

  def default_json_ld_language
    Spotlight::Engine.config.default_json_ld_language
  end
end
