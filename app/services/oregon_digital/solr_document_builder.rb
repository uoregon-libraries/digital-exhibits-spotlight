require 'open-uri'

module OregonDigital
  class SolrDocumentBuilder < Spotlight::SolrDocumentBuilder
    def to_solr
      out_doc = out_doc_init
      in_doc.each do |key, val|
        next unless key.start_with? 'desc_metadata'
        if key.include? 'label'
          out_doc.merge!(add_data(key, val))
        elsif !out_doc[key]
          out_doc[key] = val
        end
      end
      out_doc.merge!(add_tags) if has_tags?
      out_doc

      rescue NoOriginalThumbError => e
        Loggerly.debug("Unable to extract asset thumb information: #{e.message}")
      rescue UnsupportedAssetType
        Loggerly.debug("Asset type is not supported at this time.")
      rescue StandardError => e
        Loggerly.debug(e.message)
    end

    def out_doc_init
      { id: in_doc['id'].gsub('oregondigital:', ''),
        Spotlight::Engine.config.thumbnail_field => get_thumb,
        Spotlight::Engine.config.full_image_field => ENV['OD_URL'] + "/downloads/#{in_doc['id']}.jpg",
        oembed_url_ssm: "#{ENV['OD_URL']}/resource/#{in_doc['id']}",
        pid_ssm: in_doc['id'],
        spotlight_hidden_title_tesim: in_doc["desc_metadata__title_tesim"],
        model_ssi: in_doc['active_fedora_model_ssi']
      }
    end

    # method only called for data with labels
    def add_data(key, val)
      new_val = extract_label(val)
      return {} if new_val.empty?
      new_key = key.gsub('_label', '')
      { new_key => new_val,
        new_key.gsub('ssm', 'sim') => new_val,
        new_key.gsub('ssm', 'ssim') => val }
    end

    def in_doc
      @in_doc ||= get_data
    end

    def get_data
      content = JSON.parse(open(@resource.url).read)
      content['response']['document']
      rescue StandardError => e
        raise StandardError, "Unable to acquire metadata: #{e}"
    end

    def extract_label(val)
      extract = proc{ |str| str.start_with?('http') ? '' : str.split('$')[0] }
      val.respond_to?(:each) ? val.map(&extract).reject(&:empty?) : extract.call(val)
    end

    def get_thumb
      thumb = case in_doc['active_fedora_model_ssi']
        when 'Image' then "#{ENV['OD_URL']}/downloads/#{in_doc['id']}.jpg"
        when 'Document' then document_page_path
      end
      raise UnsupportedAssetType if thumb.nil?
      thumb
    end

    def document_page_path
      id = in_doc['id'].gsub(':', '-')
      "#{ENV['OD_URL']}/media/document_pages/#{buckets}/#{id}/normal-page-1.jpg"
    end

    def parse_profile
      JSON.parse(in_doc['object_profile_ssm'].first)
    end

    def buckets
      profile = parse_profile
      loc = profile['datastreams']['thumbnail']['dsLocation']
      buckets = /[a-z0-9]\/[a-z0-9]\/oregondigital/.match loc
      buckets.to_s.gsub('/oregondigital', '')
      rescue StandardError => e
        raise NoOriginalThumbError, e.message
    end

    def has_tags?
      !@resource.data[:tags].blank?
    end

    def add_tags
      {"exhibit_#{@resource.exhibit.slug}_tags_ssim" => tags }
    end

    def tags
      @resource.data[:tags].split('|').map{ |t| t.strip }
    end
  end

  class NoOriginalThumbError < StandardError
  end

  class UnsupportedAssetType < StandardError
  end

end
