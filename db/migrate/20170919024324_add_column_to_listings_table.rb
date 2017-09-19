class AddColumnToListingsTable < ActiveRecord::Migration[5.1]
  def change
    add_column :listings, :amenities, :string
  end
end
