module Spotlight
  module Resources
    class IiifListUpload
      attr_reader :file
      include ActiveModel::Model
      extend ActiveModel::Translation
    end
  end
end
