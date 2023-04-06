##
# Simplified catalog controller
class CatalogController < ApplicationController
  include Blacklight::Catalog

  def self.labelize(field)
    label_arr = field.underscore.split("_").map{ |str| str.capitalize}
    label_arr.join(" ")
  end

  before_action only: :admin do
    unless blacklight_config.view.key? :admin_table
      blacklight_config.view.admin_table(
        thumbnail_field: :thumbnail_url_ssm,
        partials: [:index_compact],
        document_actions: []
      )
    end
  end

  configure_blacklight do |config|
          config.show.oembed_field = :oembed_url_ssm
          config.show.partials.insert(1, :oembed)

#    config.view.gallery.partials = [:index_header, :index]
#    config.view.masonry.partials = [:index]
#    config.view.slideshow.partials = [:index]
    config.view.gallery(document_component: Blacklight::Gallery::DocumentComponent)
    config.view.masonry(document_component: Blacklight::Gallery::DocumentComponent)
    config.view.slideshow(document_component: Blacklight::Gallery::SlideshowComponent)

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: 'search',
      rows: 10,
      fl: '*'
    }

    config.document_solr_path = 'get'
    config.document_unique_id_param = 'ids'

    # solr field configuration for search results/index views
    config.index.title_field = ::Blacklight::Configuration::Field.new(field:'full_title_tesim', accessor: :title)

    config.add_search_field 'all_fields', label: 'Everything'

    config.add_sort_field 'relevance', sort: 'score desc', label: 'Relevance'
    config.add_index_field 'desc_metadata__set_label_ssim', label: 'Set'
    config.add_field_configuration_to_solr_request!

    #FIX ANGLE BRACKETS ON LOCATIONS
    #config.add_facet_field 'readonly_location_tesim', label: 'Region', limit: true, helper_method: :od_label
    config.add_facet_fields_to_solr_request!


    config.show.title_field = ::Blacklight::Configuration::Field.new(field:'full_title_tesim', accessor: :title)
    config.add_show_field 'pid_ssm', label: 'See it at Oregon Digital', helper_method: :od_link
    config.add_show_field 'resource_url_ssi', label: 'See Original Resource', helper_method: :iiif_link

    config.add_results_collection_tool(:sort_widget)
    config.add_results_collection_tool(:per_page_widget)
    config.add_results_collection_tool(:view_type_group)

    config.index.thumbnail_method = :document_thumbnail
    config.index.thumbnail_field = :thumbnail_url_ssm
    config.view.list.thumbnail_field = :thumbnail_url_ssm
    config.show.thumbnail_field = :thumbnail_url_ssm

    # Set which views by default only have the title displayed, e.g.,
    # config.view.gallery.title_only_by_default = true
  end

end
