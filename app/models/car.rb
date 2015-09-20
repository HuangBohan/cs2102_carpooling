class Car < ActiveRecord::Base
  belongs_to :user
  has_many :offers, dependent: :destroy
end
