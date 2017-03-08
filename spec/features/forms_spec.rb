# frozen_string_literal: true
require 'rails_helper'

describe 'Forms' do
  context 'with no user logged in' do
    it 'should redirect to the login page' do
      visit forms_path
      expect(page).to have_current_path new_user_session_path
    end
  end

  context 'with an admin logged in' do
    let!(:forms) { create_list(:form, 4) }
    before do
      login_as(create(:user))
      visit forms_path
    end

    it 'should display all four forms' do
      forms.each do |form|
        expect(page).to have_content form.name
        expect(page).to have_content form.description
      end
    end

    it 'should allow hiding forms not related to Cohorts' do
      form_to_hide = forms[rand(4)]
      within "#form-#{form_to_hide.id}" do
        find('a.ui.left.attached.icon.button').click
      end
      expect(page).to have_content "\"#{form_to_hide.name}\" hidden"
      expect(page).to_not have_content form_to_hide.description
    end
  end
end
