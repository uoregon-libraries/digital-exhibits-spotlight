# frozen_string_literal: true

module FeaturedImageBehavior

  # add blur to params defined in Spotlight::AppearancesController
  # note that this is moved to Spotlight::Concerns::ApplicationController in v3
  def featured_image_params
    [
      :iiif_region, :iiif_tilesource,
      :iiif_manifest_url, :iiif_canvas_id,
      :iiif_image_id,
      :display,
      :blur,
      :source,
      :image,
      :document_global_id
    ]
  end

  ##add blur to params defined in Spotlight::SitesController
  def masthead_params
    %i[
      display
      blur
      iiif_region
      iiif_tilesource
    ]
  end
end
