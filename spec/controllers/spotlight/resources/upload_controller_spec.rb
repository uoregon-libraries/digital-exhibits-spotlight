# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Spotlight::Resources::UploadController, type: :controller do
  routes { Spotlight::Engine.routes }
  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:user) { FactoryBot.create(:exhibit_curator, exhibit: exhibit) }

  before { sign_in user }

  describe 'POST create' do
    let(:blacklight_solr) { double }

    before do
      allow_any_instance_of(Spotlight::Resource).to receive(:reindex).and_return(true)
      allow_any_instance_of(Spotlight::Resource).to receive(:blacklight_solr).and_return blacklight_solr
    end

    it 'uploads an item' do
      post :create, params: { exhibit_id: exhibit, resources_upload: { url: 'wind-up-bird' } }
      expect(flash[:notice]).to eq 'Object uploaded successfully.'
    end

    context 'when the max number of uploads for the exhibit is reached' do
      before do
        allow(subject).to receive(:upload_total).and_return(20)
      end

      it 'stops the upload' do
        post :create, params: { exhibit_id: exhibit, resources_upload: { url: 'wind-up-bird' } }
        expect(flash[:error]).to eq I18n.t('upload_max_error')
      end
    end

    context 'when the image is too large' do
      before do
        allow(Spotlight::FeaturedImage).to receive(:new).and_raise(CarrierWave::IntegrityError, I18n.t('errors.messages.max_size_error'))
      end
      it 'stops the upload' do
        post :create, params: { exhibit_id: exhibit, resources_upload: { url: 'wind-up-bird' } }
        expect(flash[:error]).to eq I18n.t('errors.messages.max_size_error')
      end
    end
  end
end
