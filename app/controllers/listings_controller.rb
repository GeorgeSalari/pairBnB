class ListingsController < ApplicationController
  def new
    if current_user.moderator?
      flash[:notice] = "Sorry. You are not allowed to add new listing."
      return redirect_to user_path(current_user), notice: "Sorry. You are not allowed to add new listing."
    end
    @user_listing = Listing.new
  end

  def all
    if params[:city]
      @@city = params[:city]
    elsif params[:city].nil? && (defined? @@city != nil)
    else
      @@city = ""
    end
    @listings = Listing.check_user_status(params[:city], current_user).page(params[:page]).order('created_at')
    if params[:start_date] && params[:end_date]
      @start = params[:start_date]
      @end = params[:end_date]
      @listings = Listing.check_available_day(params[:start_date], params[:end_date], @@city).page(params[:page]).order('created_at')
      flash[:notice] = "No available listings in #{@@city} from #{params[:start_date].to_date} to #{params[:end_date].to_date}" if @listings.empty?
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
      render template: "listings/new"
    end
  end

  def show
    @listing = Listing.find(params[:id])
    if params[:start_date] && params[:end_date]
      @start = params[:start_date]
      @end = params[:end_date]
    end
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

  def add_images
    @listing = Listing.find(params[:id])
    new_images = params[:listing][:images]
    @listing.images += new_images
    @listing.save
    redirect_to user_listing_path(current_user, @listing)
  end

  def remove_image_at_index
    @listing = Listing.find(params[:id])
    indices = params[:listing][:images]
    images = @listing.images.select.with_index do |image, index|
      if indices.include? index.to_s
        image.try(:remove!)
        false
      else
        true
      end
    end
    if images.empty?
      @listing.remove_images!
      @listing.save
      redirect_to user_listing_path(current_user, @listing)
    else
      @listing.update(images: images)
      redirect_to user_listing_path(current_user, @listing)
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
