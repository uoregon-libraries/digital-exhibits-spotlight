require 'open-uri'

module OregonDigital
  class SolrDocumentBuilder < Spotlight::SolrDocumentBuilder
    def to_solr
      in_doc = get_data(resource.url)

      out_doc = {
        id: in_doc['id'],
        Spotlight::Engine.config.thumbnail_field => get_thumb(in_doc),
        #Spotlight::Engine.config.full_image_field => ENV['OD_URL'] + "/downloads/#{in_doc['id']}.jpg",
        oembed_url_ssm: "#{ENV['OD_URL']}/resource/#{in_doc['id']}",
        pid_ssm: in_doc['id']
      }

      in_doc.each do |key, val|
        if key.start_with? "desc_metadata"
          if key.include? "label"
            out_doc.merge!(add_data(key, val))
          elsif !out_doc[key]
            out_doc[key] = val
          end
        end
      end
      out_doc

      rescue NoOriginalThumbError
        flash[:notice] = "Import failed, could not find path for asset derivatives on OregonDigital."

      rescue UnsupportedAssetType
        flash[:notice] = "Import failed, asset type is not supported at this time"

      rescue StandardError => e
        flash[:notice] = "Something went wrong, please check logs."
        Rails.logger.error "SolrDocumentBuilder error: #{e.message}"
    end

    def add_data(key, val)
      new_val = extract_label(val)
      new_key = key.gsub("_label", "")
      out_doc = {
        new_key: new_val,
        new_key.gsub("ssm", "sim") => new_val,
        new_key.gsub("ssm", "ssim") => val
      }
    end

    def get_data(url)
        content = JSON.parse(open(url).read)
        content['response']['document']
      rescue
        raise
    end

    def extract_label(val)
      new_arr = []
      arr = (val.respond_to? :each) ? val : [val]
      arr.each do |item|
        parts = item.split("$")
        new_arr << parts[0] unless parts[0].include? "http"
      end
      new_arr
    end

    def get_thumb(in_doc)
      thumb = case in_doc['active_fedora_model_ssi']
        when "Image" then "#{ENV['OD_URL']}/downloads/#{in_doc['id']}.jpg"
        when "Document" then "#{ENV['OD_URL']}/media/document_pages/#{buckets(in_doc)}/normal-page-1.jpg"
      end
      raise UnsupportedAssetType unless !thumb.nil?
      thumb
    end

    def buckets(in_doc)
      loc = in_doc['object_profile_ssm']['datastreams']['thumbnail']['dsLocation']
      buckets = /[a-z0-9]\/[a-z0-9]\/oregondigital-[a-z0-9]{9}/.match loc
      buckets.to_s
      rescue
        raise NoOriginalThumbError
    end
  end

  class NoOriginalThumbError < StandardError
  end

  class UnsupportedAssetType < StandardError
  end

end
