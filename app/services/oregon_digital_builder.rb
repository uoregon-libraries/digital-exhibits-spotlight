require 'open-uri'
class OregonDigitalBuilder < Spotlight::SolrDocumentBuilder
  def to_solr
    doc = get_data(resource.url)
    if !doc.nil?
      {
        id: doc['id'],
        full_title_tesim: doc['desc_metadata__title_tesim'],
        Spotlight::Engine.config.thumbnail_field => ENV['OD_URL'] + "/downloads/#{doc['id']}.jpg",
        Spotlight::Engine.config.full_image_field => ENV['OD_URL'] + "/downloads/#{doc['id']}.jpg",
        oembed_url_ssm: ENV['OD_URL'] + "/resource/#{doc['id']}",
        creator_ssim: extract_label(doc['desc_metadata__creator_label_ssm']),
        photographer_ssim: extract_label(doc['desc_metadata__photographer_label_ssm']),
        description_tesim: doc['desc_metadata__description_tesim'],
        subject_ssim: extract_label(doc['desc_metadata__lcsubject_label_ssm']),
        set_ssim: extract_label(doc['desc_metadata__set_label_ssm'])
     }
    else
      nil
    end
  end

  def get_data(url)
    begin
      content = JSON.parse(open(url).read)
      content['response']['document']
    rescue
      nil
    end
  end

  def extract_label(arr)
    return [] unless !arr.nil?
    new_arr = []
    arr.each do |item|
      parts = item.split("$")
      if !parts[0].include? "http"
        new_arr << parts[0]
      end
    end
    new_arr
  end

end
