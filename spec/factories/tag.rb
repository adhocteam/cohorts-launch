# frozen_string_literal: true
FactoryGirl.define do
  factory :tag, class: Tag do
    name { Faker::Hipster.word }
    after(:build) do |tag|
      tag.name += "-#{Faker::Hipster.word}" until tag.valid?
    end
  end

  factory :tagging, class: Tagging do
    taggable_type 'Person'

    before(:create) do |tagging|
      tagging.taggable = FactoryGirl.create(:person)
      tagging.tag = FactoryGirl.create(:tag)
    end
  end
end
