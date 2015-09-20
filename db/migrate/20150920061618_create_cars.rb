class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :name
      t.integer :seats
      t.integer :owner_id, null: false
      t.foreign_key :user, column: :owner_id, index: true

      t.timestamps null: false
    end
  end
end
