# frozen_string_literal: true
class ResearchSessionsController < ApplicationController
  before_action :find_research_session, only: [:update, :destroy]
  before_action :parse_dates, only: [:create, :update]

  def index
    @research_sessions = ResearchSession.order(:datetime)
  end

  def create
    @research_session = ResearchSession.new(research_session_params)
    respond_to do |format|
      if @research_session.save
        # update_invites
        format.js {}
      else
        format.js { "console.log('Error saving research_session: #{@research_session.errors}');" }
      end
    end
  end

  def update
    @research_session.assign_attributes(research_session_params)
    respond_to do |format|
      if @research_session.save
        # update_invites
        format.js {}
      else
        format.js { "console.log('Error saving research_session: #{@research_session.errors}');" }
      end
    end
  end

  def destroy
    @research_session.destroy
    respond_to do |format|
      format.js {}
    end
  end

  private

    def find_research_session
      @research_session = ResearchSession.find(params[:id])
    end

    def parse_dates
      params[:datetime] = Time.zone.parse(params[:datetime]) if params[:datetime]
    end

    def research_session_params
      params.require(:research_session).permit(:engagement_id, :datetime, :notes, person_ids: [])
    end
end
