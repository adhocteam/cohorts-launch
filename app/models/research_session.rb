# frozen_string_literal: true
class ResearchSession < ActiveRecord::Base
  belongs_to :engagement
  delegate :client, to: :engagement
  has_many :session_invites
  has_many :people, through: :session_invites
end
