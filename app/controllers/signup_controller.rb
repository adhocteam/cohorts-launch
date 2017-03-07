# frozen_string_literal: true
class SignupController < ApplicationController
  def index
    @tag_name = params[:tag_name]
    @landing_page = LandingPage.joins(:tag).find_by('LOWER(tags.name) = ?', @tag_name)
  end
end
