# frozen_string_literal: true
FactoryGirl.define do
  factory :gift_card do
    gift_card_number 99999
    expiration_date '05/20'
    person_id 1
    notes 'MyString'
    created_by 1
    reason 1
  end
end
