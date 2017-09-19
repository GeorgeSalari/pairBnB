class ListingsController < ApplicationController
  def new
    @user_listing = Listing.new
  end

  def all
    if params[:city].nil? || params[:city].empty?
      @listings = Listing.page(params[:page]).order('created_at DESC')
    else
      @listings = Listing.where(city: params[:city]).paginate(:page => params[:page]).order('created_at DESC')
    end
  end

  def destroy
    listing = Listing.find(params[:id])
    if listing.user_id == params[:user_id].to_i
      listing.destroy
      redirect_to user_listings_path
    end
  end

  def create
    @listing = Listing.new(listing_params)
    if @listing.save
      redirect_to user_listing_path(current_user, @listing)
    else
      render template: "listing/new"
    end
  end

  def show
    @listing = Listing.find(params[:id])
  end

  def index
    @user_listings = Listing.where(user_id: params[:user_id]).paginate(:page => params[:page]).order('created_at DESC')
  end

  def edit
    @user_listing = Listing.find(params[:id])
  end

  def update
    @listing = Listing.find(params[:id])
    if @listing.update(listing_params)
      redirect_to user_listing_path(current_user, @listing)
    else
      redirect_to edit_user_listing(current_user, @listing)
    end
  end

  private

  def listing_params
    if params[:listing][:amenities]
      params[:listing][:amenities] = params[:listing][:amenities].reject{|x| x.empty?}.join(",")
    end
    params.require(:listing).permit(:name, :description, :price, :cancelation_rules, :user_id, :amenities, :city)
  end
end
