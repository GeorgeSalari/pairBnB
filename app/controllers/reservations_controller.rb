class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.where(user_id: params[:user_id])
  end

  def new
    @listing = Listing.find(params[:listing_id])
    @reservation = Reservation.new
  end

  def create
    params[:reservation][:end_date] = reservation_params[:end_date].to_date
    params[:reservation][:start_date] = reservation_params[:start_date].to_date
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to user_reservation_path(current_user, @reservation)
    else
      @listing = @reservation.listing
      flash.now[:error] = "Dates are overlapping"
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

