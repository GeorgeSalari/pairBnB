class Listing < ApplicationRecord
  belongs_to :user
  has_many :reservations, dependent: :destroy
  self.per_page = 8
  mount_uploaders :images, ListingUploader
  scope :city, -> (city) { where city: city }
  scope :verification, -> (verification) { where verification: verification }
  scope :num_of_bedrooms, -> (num_of_bedrooms) { where num_of_bedrooms: num_of_bedrooms}
  scope :num_of_bathrooms, -> (num_of_bathrooms) { where num_of_bathrooms: num_of_bathrooms}
  scope :price, -> (price) { where('price <= ?', price) }

  def self.check_user_status(city, user)
    if user.nil? || user.customer?
      if city.nil? || city.empty?
        Listing.verification(true)
      else
        Listing.city(city).verification(true)
      end
    elsif user.moderator?
      if city.nil? || city.empty?
        Listing.verification(false)
      else
        Listing.city(city).verification(false)
      end
    else
      if city.nil? || city.empty?
        Listing.all
      else
        Listing.city(city)
      end
    end
  end

  def self.check_available_day(start_day, end_day, city, user)
    @start_day = start_day
    @end_day = end_day
    listings = Listing.all.select do |listing|
      check_listing = true
      listing.reservations.each do |book|
        check_listing = false if (start_day.to_date..end_day.to_date).overlaps?(book.start_date..book.end_date)
      end
      check_listing
    end
    self.check_user_status(city, user).where(id: listings.map(&:id))
  end

  def self.get_start_day
    @start_day
  end

  def self.get_end_day
    @end_day
  end

  def self.save_city(city)
    if city
      @@city = city
    elsif city.nil? && (defined? @@city != nil)
    else
      @@city = ""
    end
  end

  def self.get_city
    @@city if (defined? @@city != nil)
  end
end
