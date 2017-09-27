module ListingsHelper
  def search_city
    @@city if (defined? @@city != nil)
  end
end
