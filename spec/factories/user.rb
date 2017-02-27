# frozen_string_literal: true
require 'faker'

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
    approved true
    name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.cell_phone }
  end
end
