# frozen_string_literal: true
class SessionInvite < ActiveRecord::Base
  belongs_to :research_session
  belongs_to :person
end
