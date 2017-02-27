# frozen_string_literal: true
FactoryGirl.define do
  factory :comment do
    content { Faker::Hipster.sentence }
    commentable_type 'Person'
    commentable_id 1
    user
  end
end
