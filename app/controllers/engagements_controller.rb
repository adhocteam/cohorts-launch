# frozen_string_literal: true
class EngagementsController < ApplicationController
  before_action :find_engagement, only: [:update, :destroy]
  before_action :parse_dates, only: [:create, :update]

  def index
    @engagements = Engagement.order(:created_at)
  end

  def create
    @engagement = Engagement.new(engagement_params)
    respond_to do |format|
      if @engagement.save
        format.js {}
      else
        format.js { "console.log('Error saving engagement: #{@engagement.errors}');" }
      end
    end
  end

  def update
    @engagement.assign_attributes(engagement_params)
    respond_to do |format|
      if @engagement.save
        format.js {}
      else
        format.js { "console.log('Error saving engagement: #{@engagement.errors}');" }
      end
    end
  end

  def destroy
    @engagement.destroy
    respond_to do |format|
      format.js {}
    end
  end

  private

    def find_engagement
      @engagement = Engagement.find(params[:id])
    end

    def parse_dates
      params[:start_date] = Date.parse(params[:start_date]) if params[:start_date]
      params[:end_date] = Date.parse(params[:end_date]) if params[:end_date]
    end

    def engagement_params
      params.require(:engagement).permit(:client_id, :topic, :start_date, :end_date, :notes, :search_query)
    end
end
