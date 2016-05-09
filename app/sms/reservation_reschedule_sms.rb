# TODO: needs a spec. The spec for SmsReservationsController covers it,
# but a unit test would make coverage more robust
class ReservationRescheduleSms < ApplicationSms
  attr_reader :to, :reservation

  def initialize(to:, reservation:)
    super
    @to = to # only really people here.
    @reservation = reservation
  end

  def send
    client.messages.create(
      from: application_number,
      to:   to.phone_number,
      body: "It looks like we'll need to reschedule the #{duration} minute interview for #{selected_time}.\n#{reservation.user.name} will get in touch with you soon to another time.\nTheir number is #{reservation.user.phone_number}")
  end

  private

    def selected_time
      reservation.time_slot.to_weekday_and_time
    end

    def duration
      reservation.duration / 60
    end
end
