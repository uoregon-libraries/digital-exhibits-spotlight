# frozen_string_literal: true
require 'rails_helper'

describe 'Add and update the site masthead', type: :feature do
  let(:exhibit) { FactoryBot.create(:exhibit, title: 'My Little Pony', slug: 'my-little-pony') }
  let(:user) { FactoryBot.create(:exhibit_admin, exhibit: exhibit) }

  before { login_as user }

  it 'displays a masthead image when one is uploaded and configured' do
    visit spotlight.exhibit_dashboard_path(exhibit)
    expect(page).to_not have_css('.image-masthead')
    within '#sidebar' do
      click_link 'Appearance'
    end

    click_link 'Exhibit masthead'

    within '#site-masthead' do
      check 'Show background image in masthead'
      uncheck 'Apply blur'

      # attach_file('exhibit_masthead_attributes_image', File.absolute_path(File.join(FIXTURES_PATH, 'avatar.png')))
      # The JS fills in these fields:
      find('#exhibit_masthead_attributes_iiif_tilesource', visible: false).set 'http://test.host/images/7'
      find('#exhibit_masthead_attributes_iiif_region', visible: false).set '0,0,100,200'
    end

    click_button 'Save changes'

    expect(page).to have_content('The exhibit was successfully updated.')

    expect(page).to have_css('.background-container-no-blur')
  end
end

