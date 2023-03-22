##
# Simplified catalog controller
class CatalogController < ApplicationController
  include Blacklight::Catalog

  def self.labelize(field)
    label_arr = field.underscore.split("_").map{ |str| str.capitalize}
    label_arr.join(" ")
  end

  configure_blacklight do |config|
          config.show.oembed_field = :oembed_url_ssm
          config.show.partials.insert(1, :oembed)

    config.view.gallery.partials = [:index_header, :index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]


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
    config.index.title_field = 'full_title_tesim'
    config.thumbnail_image_url = :oembed_url_ssm
    config.add_search_field 'all_fields', label: 'Everything'

    config.add_sort_field 'relevance', sort: 'score desc', label: 'Relevance'
    config.add_index_field 'desc_metadata__set_label_ssim', label: 'Set'

    config.add_field_configuration_to_solr_request!

    config.add_facet_field 'desc_metadata__location_ssim', label: 'Region', limit: true, helper_method: :od_label
    config.add_facet_field 'readonly_location_ssim', label: 'Region', limit: true
    config.add_facet_field 'readonly_subject_ssim', label: 'Topics', limit: true
    config.add_facet_fields_to_solr_request!

    config.add_show_field 'pid_ssm', label: 'See it at Oregon Digital', helper_method: :od_link
    config.add_show_field 'spotlight_hidden_title_tesim', label: 'hidden title'
    config.add_show_field 'spotlight_upload_title_tesim', label: 'Title'

    OregonDigital::Properties.propertyList.each do |property|
      fieldlabel = I18n.t property.to_s, :scope => :oregon_digital_properties, :default => labelize(property.to_s)
      config.add_show_field "desc_metadata__#{property.to_s}_ssm", label: fieldlabel
    end

    # Set which views by default only have the title displayed, e.g.,
    # config.view.gallery.title_only_by_default = true
  end

end
