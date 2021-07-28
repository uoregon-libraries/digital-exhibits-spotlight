# frozen_string_literal: true

FactoryBot.define do
  factory :featured_large_image, class: 'Spotlight::FeaturedImage' do
    image { Rack::Test::UploadedFile.new(File.expand_path(File.join('..', 'fixtures', 'IMG_3296.jpeg'), __dir__)) }
  end
end
