class SendLettersJob < ApplicationJob
  queue_as :default

  def perform(customer, listing, reservation_id)
    ReservationMailer.booking_email(customer, listing, reservation_id).deliver_now
  end
end
