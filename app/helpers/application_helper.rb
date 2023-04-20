module ApplicationHelper
  include SpotlightHelper
  #The link_to will need to be redone when OD2 goes live
  #Use the solr document to get at the model for creating the uri
  def od_link(args)
    link_to "https://oregondigital.org/catalog/#{args[:document][args[:field]].first}", "#{ENV['OD_URL']}/catalog/#{args[:document][args[:field]].first}"
  end

  def iiif_link(args)
    if args[:document][args[:field]].include? "oregondigital.org"
      link_to "#{args[:document][args[:field]]}", "#{args[:document][args[:field]]}"
    else
      args[:document][args[:field]]
    end
  end

  def od_label(args)
    return extract_label(args).find{|x| !x.blank?}.to_s
  end

  def extract_label(label)
    Array.wrap(label).map do |x|
      new_label = x.split("$")
      if new_label.first == new_label.last
        ""
      else
        new_label.first.strip
      end
    end
  end

#this appears to be called with view list
  def document_thumbnail(document, image_options = {})
    return unless !current_exhibit.nil?

    values = document.fetch(:thumbnail_url_ssm, nil)
    return if values.blank?

    url = values.first
    image_tag url, image_options if url.present?
  end
end
