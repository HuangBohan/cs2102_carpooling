class Request < ActiveRecord::Base
  self.primary_keys = :offer_date_time, :offer_car_license_plate_number, :requester_email
  belongs_to :requester, class_name: :User, foreign_key: :requester_email
  belongs_to :offer, foreign_key: [:offer_date_time, :offer_car_license_plate_number]
end
