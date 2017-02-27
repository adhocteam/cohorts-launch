# frozen_string_literal: true
require 'rails_helper'
require 'support/poltergeist_js_hack_for_login'
require 'capybara/email/rspec'

feature 'tag person'  do
  scenario 'add tag', js: :true  do
    pending 'Something wonky with Semantic dropdown'
    person = FactoryGirl.create(:person)
    login_with_admin_user

    tag_name = Faker::Company.buzzword
    visit "/people/#{person.id}"

    find('#new-tag input.search').set tag_name
    select_from_dropdown "Add #{tag_name}", from: 'tagging[name]'
    page.execute_script("$('form#new_tagging').submit()")
    wait_for_ajax
    sleep 1 # wait for our page to save
    # gotta reload so that we don't cache tags
    person.reload
    found_tag = person.taggings.first ? person.taggings.first.tag.name : false
    expect(found_tag).to eq(tag_name)

    visit "/people/#{person.id}"
    # should have a deletable tag there.
    expect(page.evaluate_script("$('a.delete-link').length")).to eq(1)
  end

  scenario 'delete tag', js: :true  do
    pending 'Something wonky with Semantic dropdown'
    person = FactoryGirl.create(:person, preferred_contact_method: 'EMAIL')
    login_with_admin_user

    tag_name = Faker::Company.buzzword
    visit "/people/#{person.id}"

    sleep 1
    find('#new-tag input.search').set tag_name
    sleep 1
    select_from_dropdown "Add #{tag_name}", from: 'tagging[name]'
    wait_for_ajax
    sleep 1
    page.execute_script("$('form#new_tagging').submit()")
    wait_for_ajax
    sleep 1
    expect(page.evaluate_script("$('a.delete-link').length")).to eq(1)

    expect(find(:css, '#tagging_name').value).to_not eq(tag_name)
    page.execute_script("$('a.delete-link').click();")
    wait_for_ajax
    sleep 1
    expect(page).to_not have_text(tag_name)
  end
end
