class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.where(user_id: params[:user_id])
  end

  def new
    @listing = Listing.find(params[:listing_id])
    @reservation = Reservation.new
  end

  def create
    if params[:start_date] && params[:end_date]
      @reservation = Reservation.new
      @reservation.start_date = params[:start_date].to_date
      @reservation.end_date = params[:end_date].to_date
      @listing = Listing.find(params[:listing_id])
      render template: "reservations/new"
    else
      params[:reservation][:end_date] = reservation_params[:end_date].to_date
      params[:reservation][:start_date] = reservation_params[:start_date].to_date
      @reservation = Reservation.new(reservation_params)
      if @reservation.check_overlap_day
        redirect_to braintree_new_path(listing_id: @reservation.listing_id, start_date: @reservation.start_date, end_date: @reservation.end_date)
      else
        @listing = @reservation.listing
        flash.now[:error] = "Dates are overlapping"
        render template: "reservations/new"
      end
      # if @reservation.save
      #   redirect_to user_reservation_path(current_user, @reservation)
      # else
      #   @listing = @reservation.listing
      #   flash.now[:error] = "Dates are overlapping"
      #   render template: "reservations/new"
      # end
    end
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  private

  def reservation_params
    if params[:reservation]
      params.require(:reservation).permit(:end_date, :start_date, :pax, :listing_id, :user_id)
    end
  end
end

