# frozen_string_literal: true
require 'faker'

FactoryGirl.define do
  factory :research_session do
    datetime { Faker::Time.between(2.weeks.from_now, 4.weeks.from_now) }
    notes { Faker::Hipster.paragraph }
    engagement
  end
end
