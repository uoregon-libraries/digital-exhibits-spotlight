require 'iiif/presentation'

# Subclass of Spotlight::Resources::IiifHarvester that adds the resource_url field
module Spotlight
    module Resources
        class IiifHarvesterMetadata < Spotlight::Resources::IiifHarvester
            def iiif_manifests
                resource_url = oregon_digital_url(url)
                @iiif_manifests ||= IiifServiceMetadata.parse(url, resource_url)
            end

            private
            
            def oregon_digital_url(url)
                unavailable = "Unavailable from Oregon Digital"
                return unavailable unless url.include? "oregondigital"

                return "https://oregondigital.org/concern/images/#{url.split("/").last}"
            end
        end
    end
end
