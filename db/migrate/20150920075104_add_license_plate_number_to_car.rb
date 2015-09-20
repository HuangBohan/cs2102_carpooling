class AddLicensePlateNumberToCar < ActiveRecord::Migration
  def change
    add_column :cars, :license_plate_number, :string
  end
end
