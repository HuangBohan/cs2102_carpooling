class Car < ActiveRecord::Base
  belongs_to :owner, class_name: :User
  has_many :offers, dependent: :destroy
  validate :at_least_one_seat

  def at_least_one_seat
    return if seats > 0
    errors.add(:offer, 'must have at least one seat')
  end
end
