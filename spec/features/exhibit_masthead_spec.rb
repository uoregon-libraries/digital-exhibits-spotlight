# frozen_string_literal: true

require 'rails_helper'

describe 'Add and update the site masthead', type: :feature do
  let(:user) { FactoryBot.create(:site_admin) }

  before { login_as user }

  it 'displays a masthead image for an exhibit when one is configured' do
    visit '/'
    within '.dropdown-menu' do
      click_link 'Create new exhibit'
    end
    fill_in 'Title', with: 'My exhibit title'
    click_button 'Save'

    within '#sidebar' do
      click_link 'Appearance'
    end

    within '#site-masthead' do
      check 'Show background image in masthead'
      uncheck 'Apply blur'
      find('#exhibit_masthead_attributes_iiif_tilesource', visible: false).set 'http://test.host/images/7'
      find('#exhibit_masthead_attributes_iiif_region', visible: false).set '0,0,100,200'
    end

    click_button 'Save changes'

    expect(page).to have_content('The exhibit was successfully updated.')

    expect(page).to have_css('.background-container-no-blur')
  end
end

