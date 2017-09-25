class Listing < ApplicationRecord
  belongs_to :user
  has_many :reservations, dependent: :destroy
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

  def self.check_available_day(start_day, end_day)
    aaa = Reservation.where(:end_date => start_day..end_day)
    bbb = Reservation.where(:start_date => start_day..end_day)
    byebug
  end
end
