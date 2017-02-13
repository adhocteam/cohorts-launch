# frozen_string_literal: true
class StaticController < ApplicationController
  layout 'static'
  skip_before_action :authenticate_user!

  def signup; end

  def vets_signup; end
end
