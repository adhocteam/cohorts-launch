# frozen_string_literal: true
FactoryGirl.define do
  factory :question do
    text { Faker::Hipster.sentence }
    field_id { "Field#{Faker::Number.number(3)}" }
    datatype { %w(text email phone number radio checkbox).sample }
    version_date { Faker::Time.between(1.year.ago, Time.zone.now) }
    choices { Faker::Hipster.words(rand(4)) }
    subfields do
      [].tap do |sf|
        rand(4).times { sf.push "Field#{Faker::Number.number(3)}" }
      end
    end
    form
  end
end
