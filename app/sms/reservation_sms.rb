# TODO: needs a spec. The spec for SmsReservationsController covers it,
# but a unit test would make coverage more robust
class ReservationSms < ApplicationSms
  attr_reader :to, :reservation

  def initialize(to:, reservation:)
    super
    @to = to
    @reservation = reservation
  end

  def send
    client.messages.create(
      from: application_number,
      to:   to.phone_number,
      body: "A #{duration} minute interview has been booked for #{selected_time}, with #{reservation.user.name}. \nTheir number is #{reservation.user.phone_number}\n. You'll get a reminder that morning."
    )
  end

  private

    def selected_time
      reservation.time_slot.start_datetime_human
    end

    def duration
      reservation.duration / 60
    end
end
