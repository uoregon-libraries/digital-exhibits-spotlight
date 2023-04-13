# frozen_string_literal: true

require 'fixtures/iiif_responses'
module StubIiifResponse
  def stub_iiif_response_for_url(url, response)
    allow(Spotlight::Resources::IiifService).to receive(:iiif_response).with(url).and_return(response)
  end
end
RSpec.configure do |config|
  config.include IiifResponses
  config.include StubIiifResponse
end


