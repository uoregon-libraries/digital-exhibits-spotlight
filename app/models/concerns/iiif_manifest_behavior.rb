module IiifManifestBehavior
  extend ActiveSupport::Concern
  
  def add_resource_url
    solr_hash['resource_url_ssi'] = resource_url
  end
    
  # Copying dpul BothFields fix
  def manifest_metadata

    @manifest_metadata ||=
      begin
        metadata = metadata_class.new(manifest).to_solr
        return {} if metadata.blank?

        create_sidecars_for(*metadata.keys)

        metadata.each_with_object({}) do |(key, value), hash|
          next unless (field = exhibit_custom_fields[key])

          field = BothFields.new(field)
          hash[field.field] = value
          hash[field.alternate_field] = value
        end
      end
  end
end
