class AddCoulumnToListing < ActiveRecord::Migration[5.1]
  def change
    add_column :listings, :num_of_bedrooms, :integer
    add_column :listings, :num_of_bathrooms, :integer
  end
end
