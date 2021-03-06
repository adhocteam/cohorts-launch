# frozen_string_literal: true
class Engagement < ActiveRecord::Base
  belongs_to :client, required: true
  has_many :research_sessions
  has_many :people, through: :research_sessions
  serialize :search_query, Hash

  scope :recent, -> { where('end_date > ?', Time.zone.now - 2.weeks) }
end
