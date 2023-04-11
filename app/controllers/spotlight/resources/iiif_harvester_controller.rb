module Spotlight
    module Resources
        class IiifHarvesterController < Spotlight::ResourcesController
            def resource_class
                Spotlight::Resources::IiifHarvesterMetadata
            end
        end
    end
end
