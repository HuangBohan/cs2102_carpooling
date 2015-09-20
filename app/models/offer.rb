class Offer < ActiveRecord::Base
  belongs_to :car
  has_many :requests, dependent: :destroy

  validate :valid_number_of_vacancies

  def valid_number_of_vacancies
    return if vacancies > 0 && vacancies < car.seats
    errors.add(:vacancies, 'must be within the number of seats in the car')
  end
end
