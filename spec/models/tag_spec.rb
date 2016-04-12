# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  created_by     :integer
#  created_at     :datetime
#  updated_at     :datetime
#  taggings_count :integer          default(0), not null
#

require 'rails_helper'

describe Tag do
  subject { FactoryGirl.build(:tag) }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  it 'should update counter_cache' do
    expect(subject).to be_valid
    expect(subject.taggings_count).to eq(0)

    person = FactoryGirl.create(:person)
    user   = FactoryGirl.create(:user)

    @tag = Tag.find_or_initialize_by(name: subject.name)
    @tag.created_by ||= user.id
    expect(subject.taggings_count).to eq(0)
    @tagging = Tagging.new(taggable_type: person.class.to_s,
                          taggable_id: person.id,
                          tag: subject)

    @tagging.with_user(user).save!

    subject.reload
    expect(subject.taggings_count).to eq(1)
  end

  it 'should delete unused tags' do
    person = FactoryGirl.create(:person)
    user   = FactoryGirl.create(:user)

    @tag = Tag.find_or_initialize_by(name: subject.name)
    @tag.created_by ||= user.id
    @tagging = Tagging.new(taggable_type: person.class.to_s,
                            taggable_id: person.id,
                            tag: subject)

    @tagging.with_user(user).save

    expect(subject.taggings_count).to eq(1)

    @tagging.destroy

    # the tag shouldn't exist
    expect { Tag.find(subject.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
