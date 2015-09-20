class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :requester_id, null: false
      t.foreign_key :user, index: true, column: :requester_id
      t.integer :status
      t.foreign_key :offer, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
