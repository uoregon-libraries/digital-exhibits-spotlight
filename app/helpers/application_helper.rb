module ApplicationHelper

  def od_link(in_hash)
    if in_hash[:value].first.include? "oregondigital"
      link_to "https://oregondigital.org/catalog/#{in_hash[:value].first}", "#{ENV['OD_URL']}/catalog/#{in_hash[:value].first}"
    else
      nil
    end
  end
end
