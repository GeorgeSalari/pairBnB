class Listing < ApplicationRecord
  belongs_to :user
  has_many :reservations
  self.per_page = 10
  mount_uploaders :images, ListingUploader
end
