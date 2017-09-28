module ListingsHelper


  def city
    Listing.get_city
  end
end
