class Offer < ActiveRecord::Base
  self.primary_keys = :date_time, :car_license_plate_number
  belongs_to :car, foreign_key: :car_license_plate_number
  has_many :requests, dependent: :destroy

  validate :valid_number_of_vacancies

  def valid_number_of_vacancies
    return if vacancies > 0 && vacancies < car.seats
    errors.add(:vacancies, 'must be within the number of seats in the car')
  end

  def to_sym
    "#{license_plate_number} | #{date_time}"
  end
end
