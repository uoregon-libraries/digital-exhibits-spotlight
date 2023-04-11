module Spotlight
  module Resources
    class CreateIiifResourceFromList < ActiveJob::Base
      queue_as :default

      def perform(item, exhibit)
        @params = iiif_resource_params(item)
        @iiif_resource = iiif_resource(exhibit, item)
        @iiif_resource.reindex
      end

      private

      def iiif_resource(exhibit, string)
        iiif_resource = Spotlight::Resources::IiifHarvesterMetadata.create(exhibit_id: exhibit.id, url: string.strip)
        iiif_resource.save
        iiif_resource
      end

      def iiif_resource_params(string)
        params = { url: string.strip }
        params
      end
    end
  end
end
