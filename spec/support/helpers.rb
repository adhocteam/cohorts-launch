# frozen_string_literal: true
module Helpers
  def login_with_admin_user
    user = FactoryGirl.create(:user)
    visit '/admin/users/sign_in'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  def fill_in_autocomplete(selector, value)
    el = find(selector)
    el.native.send_keys(*value.chars)
  end

  def choose_autocomplete(text)
    find('.tt-selectable').has_content?(text).click
    find(".tt-selectable:contains('#{text}').a").click
  end

  def wait_for_ajax
    counter = 0
    while page.execute_script('return $.active').to_i > 0
      counter += 1
      sleep(0.1)
      raise 'AJAX request took longer than 5 seconds.' if counter >= 50
    end
  end

  def login_user
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      sign_in user, scope: :user
    end
  end

  # for Semantic-ui dropdown https://stackoverflow.com/questions/34921509/capybara-cant-find-select-box-for-semantic-ui
  def select_from_dropdown(item_text, options)
    # find dropdown selector
    dropdown = find_field(options[:from], visible: false).first(:xpath, './/..')
    # click on dropdown
    dropdown.trigger('click')
    # click on menu item
    dropdown.find('.menu .item', text: item_text).click
  end

end
