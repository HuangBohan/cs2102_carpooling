class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.boolean :isAdmin
      t.integer :credits

      t.timestamps null: false
    end
  end
end
