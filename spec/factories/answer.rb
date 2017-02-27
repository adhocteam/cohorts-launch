# frozen_string_literal: true
require 'faker'

FactoryGirl.define do
  factory :answer do
    value { Faker::Hipster.sentence }
    question
    person
    submission
  end
end
