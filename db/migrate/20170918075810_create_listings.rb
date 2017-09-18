class CreateListings < ActiveRecord::Migration[5.1]
  def change
    create_table :listings do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :name
      t.string :description
      t.integer :price
      t.string :cancelation_rules
      t.timestamps
    end
  end
end
