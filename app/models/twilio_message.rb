# frozen_string_literal: true
class TwilioMessage < ActiveRecord::Base

  phony_normalize :to, default_country_code: 'US'
  phony_normalized_method :to, default_country_code: 'US'

  phony_normalize :from, default_country_code: 'US'
  phony_normalized_method :from, default_country_code: 'US'

  self.per_page = 15

end
