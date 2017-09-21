class ListingsController < ApplicationController
  def new
    if current_user.moderator?
      flash[:notice] = "Sorry. You are not allowed to add new listing."
      return redirect_to user_path(current_user), notice: "Sorry. You are not allowed to add new listing."
    end
    @user_listing = Listing.new
  end

  def all
    if current_user.customer?
      if params[:city].nil? || params[:city].empty?
        @listings = Listing.where(verification: true).page(params[:page]).order('created_at DESC')
      else
        @listings = Listing.where(city: params[:city], verification: true).paginate(:page => params[:page]).order('created_at DESC')
      end
    elsif current_user.moderator?
      if params[:city].nil? || params[:city].empty?
        @listings = Listing.where(verification: false).page(params[:page]).order('created_at')
      else
        @listings = Listing.where(city: params[:city], verification: false).paginate(:page => params[:page]).order('created_at')
      end
    else
      if params[:city].nil? || params[:city].empty?
        @listings = Listing.page(params[:page]).order('created_at')
      else
        @listings = Listing.where(city: params[:city]).paginate(:page => params[:page]).order('created_at')
      end
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
    if listing_params
      if @listing.update(listing_params)
        redirect_to user_listing_path(current_user, @listing)
      else
        redirect_to edit_user_listing(current_user, @listing)
      end
    else
      @listing.update(verification: true)
      flash[:notice] = "You approved #{@listing.name}"
      return redirect_to all_listings_path, notice: "You approved #{@listing.name}"
    end
  end

  private

  def listing_params
    if params[:listing]
      if params[:listing][:amenities].class == Array
        params[:listing][:amenities] = params[:listing][:amenities].join(",")
      end
      params.require(:listing).permit(:name, :description, :price, :cancelation_rules, :user_id, :amenities, :city, {images: []})
    end
  end
end
