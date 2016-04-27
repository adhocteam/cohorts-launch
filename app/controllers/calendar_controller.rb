class CalendarController < ApplicationController
  skip_before_action :authenticate_user!, if: :person?

  include ActionController::MimeResponds

  def show
    # either it's a person or it's a user.
    @visitor = @person ? @person : current_user
    if @visitor
      @reservations = @visitor.v2_reservations
    else
      redirect_to root_url
    end
  end

  def feed
    @visitor = @person ? @person : current_user
    if @visitor
      calendar = Icalendar::Calendar.new
      @visitor.v2_reservations.each { |r| calendar.add_event(r.to_ics) }
      calendar.publish
      render text: calendar.to_ical
    else
      redirect_to root_url
    end
  end

  private

    def person?
      @person = nil
      if !allowed_params[:token].blank?
        @person = Person.find_by(token: allowed_params[:token])
        # if we don't have a person, see if we have a user's token.
        @person = User.find_by(token: allowed_params[:token]) if @person.nil?
      elsif !allowed_params[:id].blank?
        @person = Person.find_by(allowed_params[:id])
      end

      @person.nil? ? false : true
    end

    def calendar_type
      res = Set.new
      res.add :v2_reservations
      allowed_params[:type].split(',').each do |type|
        case type
        when 'reservations'
          res.add :v2_reservations
        when 'time_slots'
          res.add :time_slots
        when 'event_invitations'
          res.add :event_invitations
        else
          res.add :v2_reservations
        end
      end
      return res.to_a
    end

    def allowed_params
      params.permit(:token, :id, :event_id, :user_id, :type)
    end
end
