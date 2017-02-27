# frozen_string_literal: true
require 'faker'

FactoryGirl.define do
  factory :form do
    hash_id '1hxw3af5'
    name { Faker::Hipster.sentence }
    description { Faker::Hipster.paragraph }
    url { Faker::Hipster.words(4).join('-') }
    hidden false
    created_on { Faker::Time.between(1.week.ago, 1.day.ago) }
    last_update { Faker::Time.between(1.day.ago, Time.zone.today) }
  end
end
