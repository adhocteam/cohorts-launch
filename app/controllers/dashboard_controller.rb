# frozen_string_literal: true
class DashboardController < ApplicationController

  def index
    @people             = Person.order('created_at DESC').limit(5)
    @submissions        = Submission.order('created_at DESC').where('person_id is ?', nil).limit(5)
    @recent_signups     = Person.where('signup_at > :startdate AND active = :active', { startdate: 1.week.ago, active: true }).size
    @recent_submissions = Submission.where('person_id is ? AND created_at > ?', nil, 4.weeks.ago).size
    @deactivated        = Person.unscoped.where(active: false).where('deactivated_at > ?', 1.week.ago).size
  end

end
