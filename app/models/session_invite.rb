# frozen_string_literal: true
class SessionInvite < ActiveRecord::Base
  self.primary_keys = :research_session_id, :person_id
  belongs_to :research_session, required: true
  belongs_to :person, required: true
  validates_uniqueness_of :research_session_id, scope: [:person_id]
end
