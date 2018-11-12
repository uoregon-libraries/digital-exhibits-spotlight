module OregonDigital
class Resource < Spotlight::Resource
  validates_with IsValidImportUrl
  self.document_builder_class = SolrDocumentBuilder
end
end
