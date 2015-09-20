class Request < ActiveRecord::Base
  belongs_to :requester, class_name: :User
  belongs_to :offer
  validate :at_least_one_seat

  private
  def at_least_one_seat
    return if offer.vacancies > 0
    errors.add(:offer, 'has no more vacancies')
  end
end
