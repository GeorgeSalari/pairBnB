class AddColumnVerificationToListingsTable < ActiveRecord::Migration[5.1]
  def change
    add_column :listings, :verification, :boolean
  end
end
