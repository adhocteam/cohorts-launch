# frozen_string_literal: true
class SignupController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @tag_name = params[:tag_name]
    @landing_page = LandingPage.joins(:tag).find_by('LOWER(tags.name) = ?', @tag_name)
  end
end
