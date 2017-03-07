# frozen_string_literal: true
class Tag < ActiveRecord::Base

  validates_uniqueness_of :name
  validates_presence_of   :name

  has_many :taggings
  has_one  :landing_page

  alias_attribute :value, :name
  alias_attribute :label, :name

  def tag_count
    taggings_count
  end

  def type
    'tag'
  end

  def self.most_popular(limit = 10)
    Tag.all.order(taggings_count: :desc).limit(limit)
  end

end
