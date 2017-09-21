class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  def check_available_day(start_day, end_day)
    i = start_day
    @listing = Listing.all.select do |listing|
                while i <= end_day
                  !listing.reservations.include? i
                end
              end
  end

end
