# frozen_string_literal: true
class TwilioWufoo < ActiveRecord::Base
  has_paper_trail
  # https://robots.thoughtbot.com/inject-that-rails-configuration-dependency
  class_attribute :wufoo_form_ids
  # this needs to stop. must cache!
  self.wufoo_form_ids ||= Cohorts::Application.config.wufoo.forms.collect { |i| [i.id, i.id] } unless Rails.env.test?

  validates :end_message, length: { maximum: 160 }

end
