module Spotlight
    module Resources
        class IiifHarvesterController < Spotlight::ResourcesController
            def resource_class
                Spotlight::Resources::IiifHarvesterResourceUrl
            end
        end
    end
end
