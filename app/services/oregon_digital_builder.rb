require 'open-uri'
class OregonDigitalBuilder < Spotlight::SolrDocumentBuilder
  def to_solr
    in_doc = get_data(resource.url)
    if !in_doc.nil?
      out_doc = {
        id: in_doc['id'],
        Spotlight::Engine.config.thumbnail_field => ENV['OD_URL'] + "/downloads/#{in_doc['id']}.jpg",
        Spotlight::Engine.config.full_image_field => ENV['OD_URL'] + "/downloads/#{in_doc['id']}.jpg",
        oembed_url_ssm: ENV['OD_URL'] + "/resource/#{in_doc['id']}",
      }

      in_doc.each do |key, val|
        if key.start_with? "desc_metadata"
          if key.include? "label"
            new_val = extract_label(val)
            out_doc[key.gsub("ssm", "ssim")] = new_val
            out_doc[key] = new_val
          end
          out_doc[key] = val
        end
      end
      out_doc
    end

  end

  def get_data(url)
    begin
      content = JSON.parse(open(url).read)
      content['response']['document']
    rescue
      raise
    end
  end

  def extract_label(val)
    new_arr = []
    arr = (val.respond_to? :each) ? val : [val]
    arr.each do |item|
      parts = item.split("$")
      if !parts[0].include? "http"
        new_arr << parts[0]
      end
    end
    new_arr
  end

end
