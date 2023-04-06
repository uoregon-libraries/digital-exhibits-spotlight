# Additional method to add resource url field 
module IiifManifestBehavior
    extend ActiveSupport::Concern
    def add_resource_url
        solr_hash['resource_url_ssi'] = resource_url
    end
end
