class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :listing
  validate :check_overlap_day

  def check_overlap_day
    listing = Listing.find(self.listing_id)
    not_overlap = true
    listing.reservations.each do |book|
      if (self.start_date..self.end_date).overlaps?(book.start_date..book.end_date)
        errors.add(:start_date, 'is overlapping')
        return
      end
    end
  end
end
