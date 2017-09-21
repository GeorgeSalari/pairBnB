class Listing < ApplicationRecord
  belongs_to :user
  has_many :reservations
  self.per_page = 10
  mount_uploaders :images, ListingUploader

  def self.check_user_status(city, user)
    if user.customer?
      if city.nil? || city.empty?
        listings = Listing.where(verification: true)
      else
        listings = Listing.where(city: city, verification: true)
      end
    elsif user.moderator?
      if city.nil? || city.empty?
        listings = Listing.where(verification: false)
      else
        listings = Listing.where(city: city, verification: false)
      end
    else
      if city.nil? || city.empty?
        listings = Listing.all
      else
        listings = Listing.where(city: city)
      end
    end
  end
end
