# Subclass of Spotlight::Resources::IiifService that adds the resource_url field
module Spotlight
    module Resources
        class IiifServiceResourceUrl < Spotlight::Resources::IiifService
            def initialize(url, resource_url)
                @resource_url = resource_url
                super(url)
            end

            def self.parse(url, resource_url)
                recursive_manifests(new(url, resource_url))
            end

            private

            attr_reader :resource_url

            def create_iiif_manifest(manifest, collection = nil)
                IiifManifestResourceUrl.new(url: manifest['@id'], resource_url: resource_url, manifest: manifest, collection: collection)
            end
        end
    end
end
