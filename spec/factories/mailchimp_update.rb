# frozen_string_literal: true
FactoryGirl.define do
  factory :mailchimp_update do
    raw_content { Faker::Hipster.sentence }
    email { Faker::Internet.email }
    update_type 'MyString'
    reason 'MyString'
    fired_at '2016-03-30 13:01:21'
  end
end
