# Subclass of Spotlight::Resources::IiifManifest that adds the resource_url field
module Spotlight
    module Resources
        class IiifManifestMetadata < Spotlight::Resources::IiifManifest
            def initialize(attrs = {})
                @resource_url = attrs[:resource_url]
                super
            end

            attr_reader :resource_url

            def to_solr(exhibit: nil)
                add_resource_url
                super
            end
        end
        
    end
end
