class User < ActiveRecord::Base
  has_many :cars, dependent: :destroy
end
