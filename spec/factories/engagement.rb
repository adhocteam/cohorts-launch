# frozen_string_literal: true
require 'faker'

FactoryGirl.define do
  factory :engagement do
    topic { Faker::Company.catch_phrase }
    start_date { Faker::Date.between(2.days.from_now, 2.weeks.from_now) }
    end_date { Faker::Date.between(2.weeks.from_now, 4.weeks.from_now) }
    notes { Faker::Hipster.paragraph }
    search_query { { 'tags_id_eq_all' => '1' } }
    client
  end
end
