# frozen_string_literal: true

require 'rails_helper'

describe Spotlight::Resources::IiifManifest do
  let(:url) { 'https://oregondigital.org/iiif_manifest_v2/abcde1234' }
  subject { described_class.new(url: url, manifest: manifest, collection: collection) }
  let(:collection) { double(compound_id: '1') }
  let(:manifest_fixture) { test_manifest1 }
  let(:location_label) { "Portland >> Clackamas/Multnomah/Washington Counties >> Oregon >> United States" }
  before do
    stub_iiif_response_for_url(url, manifest_fixture)
    subject.with_exhibit(exhibit)
  end

  describe '#to_solr' do
    let(:manifest) { Spotlight::Resources::IiifService.new(url).send(:object) }
    let(:exhibit) { FactoryBot.create(:exhibit) }

    describe 'metadata' do
      context 'custom class' do
        before do
          allow(Spotlight::Engine.config).to receive(:iiif_metadata_class).and_return(-> { IiifMetadata })
        end

        it 'does not use html_sanitize on all the things' do
          expect(subject.to_solr['readonly_location_tesim']).to eq [location_label]
        end
      end
    end
  end
end

