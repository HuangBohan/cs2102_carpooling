class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.datetime :datetime
      t.string :pickUpPoint
      t.string :dropOffPoint
      t.integer :vacancies
      t.references :car, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
