# frozen_string_literal: true
FactoryGirl.define do
  factory :answer do
    value { Faker::Hipster.sentence }
    question
    person
    submission
  end
end
