# frozen_string_literal: true
require 'rails_helper'

describe 'Search' do
  describe 'from the menubar' do
    let!(:person) { create(:person) }
    let!(:people) { create_list(:person, 5) }
    before do
      login_as(create(:user))
      visit admin_root_path
    end

    it 'should allow searching by first name', js: true do
      fill_in 'q_nav_bar_search_cont', with: person.first_name
      find('.search.link.icon').trigger('click')
      expect(page).to have_content person.full_name
      expect(page).to have_content person.address_fields_to_sentence
      people.each do |other_person|
        unless other_person.first_name == person.first_name
          expect(page).to_not have_content other_person.full_name
        end
      end
    end

    it 'should allow searching by last name', js: true do
      fill_in 'q_nav_bar_search_cont', with: person.last_name
      find('.search.link.icon').trigger('click')
      expect(page).to have_content person.full_name
      expect(page).to have_content person.address_fields_to_sentence
      people.each do |other_person|
        unless other_person.last_name == person.last_name
          expect(page).to_not have_content other_person.full_name
        end
      end
    end

    it 'should allow searching by full name', js: true do
      fill_in 'q_nav_bar_search_cont', with: person.full_name
      find('.search.link.icon').trigger('click')
      expect(page).to have_content person.full_name
      expect(page).to have_content person.address_fields_to_sentence
      people.each do |other_person|
        unless other_person.full_name == person.full_name
          expect(page).to_not have_content other_person.full_name
        end
      end
    end

    it 'should allow searching by email', js: true do
      fill_in 'q_nav_bar_search_cont', with: person.email_address
      find('.search.link.icon').trigger('click')
      expect(page).to have_content person.full_name
      expect(page).to have_content person.address_fields_to_sentence
      people.each do |other_person|
        unless other_person.email_address == person.email_address
          expect(page).to_not have_content other_person.full_name
        end
      end
    end

    it 'should allow searching by phone number', js: true do
      fill_in 'q_nav_bar_search_cont', with: person.phone_number
      find('.search.link.icon').trigger('click')
      expect(page).to have_content person.full_name
      expect(page).to have_content person.address_fields_to_sentence
      people.each do |other_person|
        unless other_person.phone_number == person.phone_number
          expect(page).to_not have_content other_person.full_name
        end
      end
    end
  end
  describe 'from the search page' do
    let!(:people) { create_list(:person, 5) }
    let!(:tags) { create_list(:tag, 5) }
    let!(:taggings) do
      tags.each do |tag|
        create(:tagging, tag: tag, taggable: people[rand(5)])
      end
    end
    let!(:question) { create(:question) }
    let!(:answers) do
      people.each do |person|
        create(:answer, question: question, person: person) if [true, false].sample
      end
    end
    context 'with no user logged in' do
      it 'should redirect to the login page' do
        visit search_index_path
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'with an admin logged in' do
      before do
        login_as(create(:user))
        visit search_index_path
      end

      it 'should allow searching by full name' do
        person = people[rand(4)]
        fill_in 'Full name contains', with: person.full_name
        click_on 'Search'
        expect(page).to have_content person.full_name
        expect(page).to have_content person.address_fields_to_sentence
        people.reject { |p| p == person }.each do |other_person|
          unless other_person.full_name == person.full_name
            expect(page).to_not have_content other_person.full_name
          end
        end
      end

      it 'should allow searching by email' do
        person = people[rand(4)]
        fill_in 'Email address contains', with: person.email_address
        click_on 'Search'
        expect(page).to have_content person.full_name
        expect(page).to have_content person.address_fields_to_sentence
        people.reject { |p| p == person }.each do |other_person|
          unless other_person.email_address == person.email_address
            expect(page).to_not have_content other_person.full_name
          end
        end
      end

      it 'should allow searching by phone number' do
        person = people[rand(4)]
        fill_in 'Phone number contains', with: person.phone_number
        click_on 'Search'
        expect(page).to have_content person.full_name
        expect(page).to have_content person.address_fields_to_sentence
        people.reject { |p| p == person }.each do |other_person|
          unless other_person.phone_number == person.phone_number
            expect(page).to_not have_content other_person.full_name
          end
        end
      end

      it 'should allow searching by address 1' do
        person = people[rand(4)]
        fill_in 'Address 1 contains', with: person.address_1
        click_on 'Search'
        expect(page).to have_content person.full_name
        expect(page).to have_content person.address_fields_to_sentence
        people.reject { |p| p == person }.each do |other_person|
          unless other_person.address_1 == person.address_1
            expect(page).to_not have_content other_person.full_name
          end
        end
      end

      it 'should allow filtering by a single tag' do
        tag = tags[rand(4)]
        select tag.name, from: 'Has tags'
        click_on 'Search'
        people.each do |person|
          if person.tags.include? tag
            expect(page).to have_content person.full_name
          else
            expect(page).to_not have_content person.full_name
          end
        end
      end

      it 'should allow filtering by multiple tags' do
        tag1 = tags[rand(4)]
        tag2 = (tags - [tag1])[rand(3)]
        select tag1.name, from: 'Has tags'
        select tag2.name, from: 'Has tags'
        click_on 'Search'
        people.each do |person|
          if person.tags.include?(tag1) || person.tags.include?(tag2)
            expect(page).to have_content person.full_name
          else
            expect(page).to_not have_content person.full_name
          end
        end
      end

      it 'should allow filtering by preferred contact method' do
        select 'Email', from: 'Preferred contact method'
        click_on 'Search'
        people.each do |person|
          if person.preferred_contact_method == 'EMAIL'
            expect(page).to have_content person.full_name
          else
            expect(page).to_not have_content person.full_name
          end
        end
      end

      it 'should allow filtering by zip leading digits' do
        fill_in 'Postal code starts with', with: '2'
        click_on 'Search'
        people.each do |person|
          if person.postal_code.start_with? '2'
            expect(page).to have_content person.full_name
          else
            expect(page).to_not have_content person.full_name
          end
        end
      end

      it 'should allow filtering by primary device' do
        devices = Cohorts::Application.config.device_mappings
        device = devices.keys.sample
        select device, from: 'Primary device'
        click_on 'Search'
        people.each do |person|
          if person.primary_device_id == devices[device]
            expect(page).to have_content person.full_name
          else
            expect(page).to_not have_content person.full_name
          end
        end
      end

      it 'should allow filtering by primary connection' do
        connections = Cohorts::Application.config.connection_mappings
        connection = connections[connections.keys.sample]
        find('#q_primary_connection_id_in').find("option[value='#{connection}']").select_option
        click_on 'Search'
        people.each do |person|
          if person.primary_connection_id == connection
            expect(page).to have_content person.full_name
          else
            expect(page).to_not have_content person.full_name
          end
        end
      end

      it 'should allow filtering by whether a person has answered a specific question' do
        select question.text, from: 'Has answered any of'
        click_on 'Search'
        people.each do |person|
          if person.questions.include? question
            expect(page).to have_content person.full_name
          else
            expect(page).to_not have_content person.full_name
          end
        end
      end

      it 'should allow bulk tagging with an existing tag', js: true do
        bulk_tag = tags[0]
        find('#bulk-tagging-field .dropdown.icon').trigger('click')
        expect(page).to have_content bulk_tag.name
        within '#bulk-tagging-field' do
          find('.menu .item', text: bulk_tag.name).trigger('click')
          find('.submit.button').trigger('click')
        end
        expect(page).to have_selector('.tag-name.detail', text: bulk_tag.name, count: Person.count)
      end

      it 'should allow saving a search to an engagement', js: true do
        pending('needs to be rewritten for a non-modal case')
        engagement = create(:engagement)
        person = people[rand(4)]
        fill_in 'Full name contains', with: person.full_name
        within 'form.main-search#person_search' do
          find('.ui.green.button').trigger('click')
        end
        within '#save-to-engagement-field' do
          find('.dropdown.icon').trigger('click')
          select_from_dropdown "#{engagement.topic} (#{engagement.client.name})", from: 'engagement[id]'
          find('.submit.button').trigger('click')
        end
        expect(page).to have_content 'Saved'
        visit engagements_path
        find('.modal-show', text: engagement.topic).click
        click_on 'Go to search'
        expect(page).to have_content 'Search Parameters: full_name_cont'
      end

      it 'should allow exporting a CSV of results' do
        click_on 'Export list as CSV'
        expect(page.response_headers['Content-Disposition']).to include 'attachment'
        expect(page.response_headers['Content-Disposition']).to include 'csv'
      end
    end
  end
end
