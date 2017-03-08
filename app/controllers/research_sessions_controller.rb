# frozen_string_literal: true
class ResearchSessionsController < ApplicationController
  before_action :find_engagement
  before_action :find_research_session, only: [:show, :edit, :update, :destroy]
  before_action :parse_dates, only: [:create, :update]

  def index
    @research_sessions = ResearchSession.order(:datetime)
  end

  def create
    @research_session = ResearchSession.new(research_session_params)
    if @research_session.save
      redirect_to @engagement, notice: 'Session was created.'
    else
      flash[:error] = @research_session.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @research_session.update_attributes(research_session_params)
      redirect_to @engagement, notice: 'Session was updated.'
    else
      flash[:error] = @research_session.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @research_session.destroy
      flash[:notice] = 'Session was deleted.'
    else
      flash[:error] = 'Problem deleting session.'
    end

    redirect_to @engagement
  end

  private

    def find_engagement
      @engagement = Engagement.find(params[:engagement_id])
    end

    def find_research_session
      @research_session = @engagement.research_sessions.find(params[:id])
    end

    def parse_dates
      params[:datetime] = Time.zone.parse(params[:datetime]) if params[:datetime]
    end

    def research_session_params
      params.require(:research_session).permit(:engagement_id, :datetime, :notes, person_ids: [])
    end
end
