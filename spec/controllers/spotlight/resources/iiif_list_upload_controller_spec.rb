# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Spotlight::Resources::IiifListUploadController, type: :controller do
    let(:exhibit) { FactoryBot.create(:exhibit) }
    let(:user) { FactoryBot.create(:exhibit_curator, exhibit: exhibit) }

    before { sign_in user }

    # file with three iiif manifest links
    let(:file) { fixture_file_upload('iiif_manifest_list.txt') }

    describe 'POST create' do

        it 'starts a CreateIiifResourceFromList job with each url in the file' do 
            expect(Spotlight::Resources::CreateIiifResourceFromList).to receive(:perform_later).and_return(nil).exactly(3).times
            post :create, params: { exhibit_id: exhibit, resources_iiif_list_upload: {file: file}}
        end

        it 'sets the flash message' do
            expect(Spotlight::Resources::CreateIiifResourceFromList).to receive(:perform_later).and_return(nil).exactly(3).times
            post :create, params: { exhibit_id: exhibit, resources_iiif_list_upload: {file: file}}
            expect(flash[:notice]).to eq "File uploaded, items are being processed."
        end

        it 'redirects back' do
            expect(Spotlight::Resources::CreateIiifResourceFromList).to receive(:perform_later).and_return(nil).exactly(3).times
            post :create, params: { exhibit_id: exhibit, resources_iiif_list_upload: {file: file}}
            expect(response).to redirect_to "http://test.host/spotlight/#{exhibit.slug}/catalog/admin?sort=timestamp"
        end
    end
end
