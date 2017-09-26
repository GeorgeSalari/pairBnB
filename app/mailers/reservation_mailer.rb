class ReservationMailer < ApplicationMailer
  def booking_email(customer, host, reservation_id)
    @customer = customer
    @host = host
    @reservation_id = reservation_id
    mail(to: @host.user.email, subject: 'You listing was book')
  end
end
