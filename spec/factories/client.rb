# frozen_string_literal: true
require 'faker'

FactoryGirl.define do
  factory :client do
    name { Faker::App.name }
  end
end
