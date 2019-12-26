module ApplicationHelper

  #The link_to will need to be redone when OD2 goes live
  #Use the solr document to get at the model for creating the uri
  def od_link(args)
    link_to "https://oregondigital.org/catalog/#{args[:document][args[:field]].first}", "#{ENV['OD_URL']}/catalog/#{args[:document][args[:field]].first}"
  end
end
