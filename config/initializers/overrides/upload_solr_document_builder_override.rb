Spotlight::UploadSolrDocumentBuilder.class_eval do
  def to_solr
    super.tap do |solr_hash|
      add_default_solr_fields solr_hash
      add_sidecar_fields solr_hash
      add_title solr_hash

      if attached_file?
        add_image_dimensions solr_hash
        add_file_versions solr_hash
        add_manifest_path solr_hash
      end
    end
  end

  def add_title(solr_hash)
    solr_hash[:spotlight_hidden_title_tesim] = solr_hash[:spotlight_upload_title_tesim]
  end
end
