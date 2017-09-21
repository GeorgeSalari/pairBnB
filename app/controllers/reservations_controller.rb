class ReservationsController < ApplicationController
  def new
    @listing = Listing.find(params[:listing_id])
    @reservation = Reservation.new
  end

  def create
    params[:reservation][:end_date] = Date.strptime(reservation_params[:end_date], '%m/%d/%Y')
    params[:reservation][:start_date] = Date.strptime(reservation_params[:start_date], '%m/%d/%Y')
    @reservation = Reservation.new(reservation_params)
    byebug
    if @reservation.save
      redirect_to user_reservation_path(current_user, @reservation)
    else
      render template: "reservations/new"
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  private

  def reservation_params
    params.require(:reservation).permit(:end_date, :start_date, :pax, :listing_id, :user_id)
  end
end

