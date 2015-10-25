class Request < ActiveRecord::Base
  self.primary_keys = :offer_datetime, :offer_car_license_plate_number, :requester_username
  belongs_to :requester, class_name: :User, foreign_key: :requester_username
  belongs_to :offer, foreign_key: [:offer_datetime, :offer_car_license_plate_number]

  validate :enough_money
  def enough_money
    return if current_user.credits >= offer.cost
    errors.add(:request, 'must have enough money')
  end

end
