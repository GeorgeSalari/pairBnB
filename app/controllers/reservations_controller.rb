class ReservationsController < ApplicationController
  def new
    @listing = Listing.find(params[:listing_id])
    @reservation = Reservation.new
  end

  def create
    byebug
    @reservation = Reservation.new(reservation_params)
  end

  private

  def reservation_params
    params.require(:reservation).permit(:end_date, :start_date, :pax, :listing_id, :user_id)
  end
end

