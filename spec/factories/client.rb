# frozen_string_literal: true
FactoryGirl.define do
  factory :client do
    name { Faker::App.name }
  end
end
