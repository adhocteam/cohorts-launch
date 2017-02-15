# frozen_string_literal: true
class Client < ActiveRecord::Base
  has_many :engagements
  has_many :research_sessions, through: :engagements
end
