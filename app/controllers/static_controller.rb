# frozen_string_literal: true
class StaticController < ApplicationController
  layout 'static'
  skip_before_action :authenticate_user!

  def signup
    @page_title = 'Cohorts'
  end

  def vets_signup
    @page_title = 'Cohorts: Veteran feedback signup'
  end
end
