# frozen_string_literal: true

require 'rails_helper'

describe 'Add and update the site masthead', type: :feature do
  let(:user) { FactoryBot.create(:site_admin) }

  before { login_as user }

  it 'updates site masthead options' do
    visit spotlight.edit_site_path

    click_link 'Site masthead'

    within '#site-masthead' do
      check 'Show background image in masthead'
      uncheck 'Apply blur' #id=site_masthead_attributes_blur
      find('#site_masthead_attributes_iiif_tilesource', visible: false).set 'http://test.host/images/7'
      find('#site_masthead_attributes_iiif_region', visible: false).set '0,0,100,200'
    end

    click_button 'Save changes'

    expect(page).to have_content('The site was successfully updated.')
    expect(page).to have_css('.background-container-no-blur')
  end
end

