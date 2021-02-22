module ApplicationHelper

  #The link_to will need to be redone when OD2 goes live
  #Use the solr document to get at the model for creating the uri
  def od_link(args)
    link_to "https://oregondigital.org/catalog/#{args[:document][args[:field]].first}", "#{ENV['OD_URL']}/catalog/#{args[:document][args[:field]].first}"
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
end
