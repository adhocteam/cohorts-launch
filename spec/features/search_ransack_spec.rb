# frozen_string_literal: true
require 'rails_helper'
require 'capybara/email/rspec'

feature 'search using ransack'  do
  before do
    @person_one = FactoryGirl.create(:person, postal_code: '60606', preferred_contact_method: 'SMS')
  end

  scenario 'with no parameters' do
    login_with_admin_user
    visit '/admin/search/index'
    click_button 'Search'
    expect(page).to have_text('Showing 1 results of 1 total')
  end

  scenario 'with matching parameters' do
    login_with_admin_user
    visit '/admin/search/index'
    fill_in 'q_postal_code_start', with: '606'
    click_button 'Search'
    expect(page).to have_text('Showing 1 results of 1 total')
  end

  scenario 'with no matching parameters' do
    login_with_admin_user
    visit '/admin/search/index'
    fill_in 'q_postal_code_start', with: '901'
    click_button 'Search'
    expect(page).to have_text('There are no Cohorts members that match your search')
  end

  # scenario 'export search results to csv' do
  # end
end
