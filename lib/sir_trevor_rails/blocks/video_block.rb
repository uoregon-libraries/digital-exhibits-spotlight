module SirTrevorRails
  module Blocks
    class VideoBlock < SirTrevorRails::Block
      def to_partial_path
        return "spotlight/sir_trevor/blocks/empty" if self.source.blank?
        "sir_trevor/blocks/videos/" << self.source
      end 
    end
  end
end
