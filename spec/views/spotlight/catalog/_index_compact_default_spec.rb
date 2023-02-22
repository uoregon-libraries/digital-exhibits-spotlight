# frozen_string_literal: true
require 'rails_helper'

# unclear why at present but rails couldn't find the admin thumbnail template
RSpec.describe "spotlight/catalog/_index_compact_default", type: :view do
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:document) { SolrDocument.new(id: 'abcde1234', full_title_tesim: 'Red', thumbnail_url_ssm: ['http://iiif.blah.org/iiif/red-img.png']) }
  let(:blacklight_config) { CatalogController.blacklight_config }
  
  before do
    without_partial_double_verification do
      allow(view).to receive_messages(blacklight_config: blacklight_config, current_exhibit: exhibit, search_session: {}, current_search_session: {})
      allow(view.main_app).to receive(:track_test_path).and_return('/track')
      allow(view).to receive(:view_link).and_return "</a>"
      allow(view).to receive(:exhibit_edit_link).and_return "</a>"
      allow(view).to receive(:visibility_exhibit_solr_document_path).and_return('')
    end

    assign(:response, instance_double(Blacklight::Solr::Response, documents: [document], start: 1, grouped?: false, empty?: false))
  end

  it "includes thumbnails" do
    render(partial: "spotlight/catalog/index_compact_default", locals: { document: document, document_counter: 0 })
    expect(rendered).to have_selector(".spotlight-admin-thumbnail")
  end
end

