class AddImagesToListings < ActiveRecord::Migration[5.1]
  def change
    add_column :listings, :images, :json
  end
end
