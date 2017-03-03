# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    content { Faker::Hipster.sentence }
    commentable_type 'Person'
    user_id 1
  end
end
