# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Spotlight::FeaturedImage do
  context 'when file_size exceeds max' do
    it 'raises an error' do
      expect { FactoryBot.create(:featured_large_image) }.to raise_error(
        CarrierWave::IntegrityError, 'File size should be less than 1048576'
      )
    end
  end
end
