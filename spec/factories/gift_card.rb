# frozen_string_literal: true
FactoryGirl.define do
  factory :gift_card do
    gift_card_number { Faker::Number.number(5) }
    batch_id { Faker::Number.number(4) }
    expiration_date '05/20'
    person_id 1
    notes { Faker::Hipster.sentence }
    created_by 1
    reason 1
  end
end
