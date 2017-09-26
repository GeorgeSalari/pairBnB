class BraintreeController < ApplicationController
  def new
    @listing = Listing.find(params[:listing_id])
    @start = params[:start_date]
    @end = params[:end_date]
    @client_token = Braintree::ClientToken.generate
  end
end
