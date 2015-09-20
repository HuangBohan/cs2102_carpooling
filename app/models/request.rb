class Request < ActiveRecord::Base
  belongs_to :requester, class_name: :User
  belongs_to :offer
end
