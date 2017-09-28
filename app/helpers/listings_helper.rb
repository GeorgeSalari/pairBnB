module ListingsHelper
  def start_date
    Listing.get_start_day
  end

  def end_date
    Listing.get_end_day
  end

  def city
    Listing.get_city
  end
end
