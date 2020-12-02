require 'rails_helper'

RSpec.describe OregonDigital::SolrDocumentBuilder do
  let(:service) { described_class.new(resource) }
  let(:resource) { instance_double('OregonDigital::Resource') }
  let(:exhibit) { instance_double('Spotlight::Exhibit') }
  
  describe '#buckets' do
    let(:in_doc) { { 'object_profile_ssm'=>[str] } }
    before do
      allow(service).to receive(:in_doc).and_return(in_doc)
    end
    context 'when there is a valid thumbnail location' do
      let(:str) { "{\"datastreams\":{\"thumbnail\":{\"dsLocation\":\"file:///var/www/hydra/releases/20150526185105/media/thumbnails/2/4/oregondigital-df67xm742.jpg\"}}}" }
      it 'returns the bucket path' do
        expect(service.send(:buckets)).to eq('2/4')
      end
    end
    context 'when there is not a valid thumbnail location' do
      let(:str) { "{\"datastreams\":{}}" }
      let(:error) { OregonDigital::NoOriginalThumbError }
      it 'raises a NoOriginalThumbError' do
        expect{service.send(:buckets)}.to raise_error(error)
      end
    end
  end
  
  describe '#get_thumb' do
    let(:od_url) { 'https://oregondigital.org' }
    before do
      allow(service).to receive(:in_doc).and_return(in_doc)
    end
    context 'when asset is an image' do
      let(:in_doc) { { 'active_fedora_model_ssi'=>'Image', 'id' => 'oregondigital:abcde1234' } }
      it 'returns a thumbnail location' do
        expect(service.send(:get_thumb)).to eq("#{od_url}/downloads/oregondigital:abcde1234.jpg")
      end
    end
    context 'when asset is a document' do
      let(:in_doc) { { 'active_fedora_model_ssi'=>'Document', 'id' => 'oregondigital:abcde1234' } }
      before do
        allow(service).to receive(:buckets).and_return('a/2')
      end
      it 'returns a thumbnail location' do
        expect(service.send(:get_thumb)).to eq("#{od_url}/media/document_pages/a/2/oregondigital-abcde1234/normal-page-1.jpg")
      end
    end
    context 'when asset is unsupported' do
      let(:error) { OregonDigital::UnsupportedAssetType }
      let(:in_doc) { { 'active_fedora_model_ssi'=>'Audio', 'id' => 'oregondigital:abcde1234' } }
      it 'raises an UnsupportedAssetType error' do
        expect{service.send(:get_thumb)}.to raise_error(error)
      end
    end
  end

  describe '#extract_label' do
    context 'when there is a label' do
      let(:val) { 'Hello Kitty (Fictitious character)$http://id.loc.gov/authorities/names/no2015121100' }
      it 'returns the label' do
        expect(service.send(:extract_label, val)).to eq('Hello Kitty (Fictitious character)')
      end
    end
    context 'when there is an array of vals' do
      let(:val) do
        ['Hello Kitty (Fictitious character)$http://id.loc.gov/authorities/names/no2015121100',
         'Cthulhu (Fictitious character)$http://id.loc.gov/authorities/names/no2017024148']
      end
      it 'returns an array of labels' do
        expect(service.send(:extract_label, val)).to eq(['Hello Kitty (Fictitious character)', 'Cthulhu (Fictitious character)'])
      end
    end
    context 'when there is a val in an array with no label' do
      let(:val) { ['http://id.loc.gov/authorities/names/no2015121100$http://id.loc.gov/authorities/names/no2015121100'] }
      it 'returns empty' do
        expect(service.send(:extract_label, val)).to eq([])
      end
    end
  end

  describe '#add_data' do
    context 'when there is a label' do
      let(:key) {'desc_metadata__commonNames_label_ssm'}
      let(:val) {['dumbo octopus$http://opaquenamespace.org/ns/commonNames/dumbooctopus']}
      let(:result) do
        { 'desc_metadata__commonNames_ssm' =>['dumbo octopus'],
          'desc_metadata__commonNames_sim'=>['dumbo octopus'],
          'desc_metadata__commonNames_ssim'=>['dumbo octopus$http://opaquenamespace.org/ns/commonNames/dumbooctopus'] }
      end
      it 'returns a hash' do
        expect(service.send(:add_data, key, val)).to eq(result)
      end
    end
    context 'when there is no label' do
      let(:key) {'desc_metadata__commonNames_label_ssm'}
      let(:val) {'http://opaquenamespace.org/ns/commonNames/idontexist$http://opaquenamespace.org/ns/commonNames/idontexist'}
      it 'returns an empty hash' do
        expect(service.send(:add_data, key, val)).to eq( {} )
      end
    end
  end

  describe '#to_solr' do
      let(:in_doc) { JSON.parse(File.read(File.join(Rails.root, 'spec/fixtures/oregondigital-df718t91z.json')))['response']['document'] }
      let(:data) { {:tags => ['pufferfish']} }
    context 'when in_doc is fetched' do
      before do
        allow(service).to receive(:in_doc).and_return(in_doc)
        allow(resource).to receive(:data).and_return(data)
        allow(resource).to receive(:exhibit).and_return(exhibit)
        allow(exhibit).to receive(:slug).and_return('fugu')
      end
      it 'populates out_doc' do
        expect(service.send(:to_solr)).to include(:id)
      end
      it 'adds metadata that has a label' do
        expect(service.send(:to_solr)).to include("desc_metadata__creator_sim")
      end
      it 'adds metadata that is a string' do
        expect(service.send(:to_solr)).to include("desc_metadata__title_tesim")
      end
      it 'adds tags' do
        expect(service.send(:to_solr)).to include("exhibit_fugu_tags_ssim")
      end
    end
    context 'when in_doc has no thumbnail' do
      let(:profile) { { 'datastreams'=>{} } }
      before do
        in_doc['active_fedora_model_ssi'] = 'Document'
        allow(service).to receive(:in_doc).and_return(in_doc)
        allow(service).to receive(:parse_profile).and_return(profile)
      end
      it 'logs the error' do
        expect(OregonDigital::Loggerly).to receive(:debug)
        service.send(:to_solr)
      end
    end
    context 'when the asset is not supported' do
      before do
        in_doc['active_fedora_model_ssi'] = 'Audio'
        allow(service).to receive(:in_doc).and_return(in_doc)
      end
      it 'logs the error' do
        expect(OregonDigital::Loggerly).to receive(:debug)
        service.send(:to_solr)
      end
    end
    context 'when there is a problem parsing the in_doc' do
      let(:error) { StandardError }
      before do
        allow(service).to receive(:get_data).and_raise(error)
      end
      it 'logs the error' do
        expect(OregonDigital::Loggerly).to receive(:debug)
        service.to_solr
      end
    end
  end
end
