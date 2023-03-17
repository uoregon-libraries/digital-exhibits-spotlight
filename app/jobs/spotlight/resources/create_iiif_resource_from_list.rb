module Spotlight
  module Resources
    class CreateIiifResourceFromList < ActiveJob::Base
      queue_as :default

      def perform(item, exhibit)
        @params = iiif_resource_params(item)
        @iiif_resource = iiif_resource(exhibit, item)
        @iiif_resource.reindex
      rescue StandardError => e
        Loggerly.debug "#{@params} #{e.message}"
      end

      private

      def iiif_resource(exhibit, string)
        iiif_resource = Spotlight::Resources::IiifHarvester.create(exhibit_id: exhibit.id, url: string.strip)
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
