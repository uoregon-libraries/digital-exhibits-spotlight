class IsValidImportUrl < ActiveModel::Validator
  def validate(record)
    begin
      uri = URI.parse(record.url.to_s)
    rescue
      record.errors.add(:url, "is not a URL")
      record.errors.add(:base, "URL is not valid")
      return
    end

    unless allowed_uri(uri)
      record.errors.add(:url, "is not an allowed import URL")
      record.errors.add(:base, "URL is not allowed for import.")
    end

  end

  private

  def allowed_uri(uri)
    ((uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)) && (uri.to_s.include? ".json"))
  end
end
