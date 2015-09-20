class Offer < ActiveRecord::Base
  belongs_to :car
  has_many :requests, dependent: :destroy
end
