# frozen_string_literal: true
FactoryGirl.define do
  factory :submission do
    raw_content { Faker::Hipster.paragraph }
    ip_addr { Faker::Internet.ip_v4_address }
    entry_id { rand(5) + 1 }
    form_structure { Faker::Hipster.paragraph }
    field_structure { Faker::Hipster.paragraph }
    form_type 'screening'
    person
    form
  end
end
