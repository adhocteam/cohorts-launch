# frozen_string_literal: true
require 'rails_helper'

describe 'People' do
  describe 'index' do
    let!(:people) { create_list(:person, 5) }
    let!(:tag) { create(:tag, name: 'suave') }
    let!(:tagging) { create(:tagging, tag_id: tag.id, taggable_id: people.first.id) }
    context 'with no user logged in' do
      it 'should redirect to the login page' do
        visit people_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'with an admin logged in' do
      before do
        login_as(create(:user))
        visit people_path
      end

      it 'should show a list of people' do
        people.each do |person|
          expect(page).to have_content(person.initials)
          expect(page).to have_content(person.city_state_to_sentence)
          expect(page).to have_content(person.created_at.to_s(:short))
        end
      end

      it 'should allow filtering by tag', js: true do
        find('.ui.action.input .ui.dropdown').click
        expect(page).to have_content 'suave'
        find('.item', text: 'suave').click
        page.execute_script("$('form#tag-filter-form').submit()")
        expect(page).to have_content people.first.initials
        unless people.last.initials == people.first.initials
          expect(page).to_not have_content people.last.initials
        end
      end

      it 'should allow visiting a persons show page' do
        expect(page).to have_link people.first.initials
        find("#person-#{people.first.id}").first(:link, people.first.initials).click
        expect(page).to have_current_path person_path(people.first)
      end

      it 'should allow editing a person' do
        expect(page).to have_link 'Edit'
        find("#person-#{people.first.id}").first(:link, 'Edit').click
        expect(page).to have_current_path edit_person_path(people.first)
      end

      it 'should allow deactivating a person', js: true do
        expect(page).to have_content 'Deactivate'
        accept_confirm_from do
          find("#person-#{people.first.id}").first(:link, 'Deactivate').click
        end
        expect(page).to have_current_path people_path
        expect(page).to have_content "#{people.first.full_name} deactivated"
      end

      it 'should allow deleting a person', js: true do
        expect(page).to have_content 'Delete'
        accept_confirm_from do
          find("#person-#{people.first.id}").first(:link, 'Delete').click
        end
        expect(page).to have_current_path people_path
        expect(page).to have_content "#{people.first.full_name} deleted"
      end
    end
  end
end
