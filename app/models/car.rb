class Car < ActiveRecord::Base
  belongs_to :owner, class_name: :User
  has_many :offers, dependent: :destroy
end
