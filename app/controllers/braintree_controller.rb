class BraintreeController < ApplicationController
  def new
    @listing = Listing.find(params[:listing_id])
    @start = params[:start_date]
    @end = params[:end_date]
    @client_token = Braintree::ClientToken.generate
  end

  def checkout
    nonce_from_the_client = params[:checkout_form][:payment_method_nonce]
    listing = Listing.find(params[:listing_id])
    start_date = params[:start_date]
    end_date = params[:end_date]
    amount = listing.price * (end_date.to_date - start_date.to_date).to_i
    result = Braintree::Transaction.sale(
     :amount => "#{amount}",
     :payment_method_nonce => nonce_from_the_client,
     :options => {
        :submit_for_settlement => true
      }
     )

    if result.success?
      @listing = Listing.find(params[:listing_id])
      @reservation = Reservation.new()
      @reservation.user_id = current_user.id
      @reservation.listing_id = params[:listing_id]
      @reservation.start_date = params[:start_date].to_date
      @reservation.end_date = params[:end_date].to_date
      @reservation.save
      customer = @reservation.user
      SendLettersJob.perform(customer, @listing, @reservation.id)
      redirect_to user_reservation_path(current_user, @reservation), :flash => { :success => "Transaction successful!" }
    else
      @reservation = Reservation.new
      @reservation.start_date = params[:start_date].to_date
      @reservation.end_date = params[:end_date].to_date
      @listing = Listing.find(params[:listing_id])
      flash.now[:danger] = "Transaction failed. Please try again."
      render template: "reservations/new"
    end
  end
end
