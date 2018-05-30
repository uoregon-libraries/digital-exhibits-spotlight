class OregonDigitalResource < Spotlight::Resource
  validates_with IsValidImportUrl
  self.document_builder_class = OregonDigitalBuilder
end
