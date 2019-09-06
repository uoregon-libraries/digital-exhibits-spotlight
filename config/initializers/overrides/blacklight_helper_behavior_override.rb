Blacklight::BlacklightHelperBehavior.module_eval do
  def render_document_title_header (document)
    title = !document["spotlight_hidden_title_tesim"].blank? ? document["spotlight_hidden_title_tesim"].first : ""
    content_tag('h1', title, itemprop: "name")
  end
end
