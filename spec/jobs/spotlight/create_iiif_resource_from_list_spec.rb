require 'rails_helper'

RSpec.describe Spotlight::Resources::CreateIiifResourceFromList, type: :job do
  include ActiveJob::TestHelper
  subject(:job) { described_class.new(url, exhibit, user) }

  let(:exhibit) { FactoryBot.create(:exhibit) }
  let(:user) { FactoryBot.create(:exhibit_curator, exhibit: exhibit) }
  let(:url) { "https://oregondigital.org/iiif_manifest_v2/fx719n514" }

  let(:resource_x) { double }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  context 'when there is a job to run' do
    let(:job) {described_class.perform_later(url, exhibit)}

    before do 
      allow(Spotlight::Resources::IiifHarvester).to receive(:create).and_return(resource_x)
      allow(resource_x).to receive(:save)
      allow(resource_x).to receive(:reindex)
    end

    it 'creates iiif resource' do
      expect(Spotlight::Resources::IiifHarvester).to receive(:create)
      perform_enqueued_jobs { job }
    end
  end

  context 'when there is a job to be queued' do 
    let!(:job) {described_class.perform_later(url, exhibit)}
    
    it 'shows up in the queue' do
      expect(ActiveJob::Base.queue_adapter.enqueued_jobs.count).to eq 1
    end
  end
end
