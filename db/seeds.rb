# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.create(
  username: 'test',
  password: '12345678',
  password_confirmation: '12345678',
  isAdmin: true
)

car = Car.create(
  owner: user,
  name: 'Batman Car',
  license_plate_number: 'ZSDFADSFAS',
  seats: 11
)

offer = Offer.create(
  car: car,
  pickUpPoint: 'NUS',
  dropOffPoint: 'NTU',
  vacancies: 10,
  cost: 10,
  datetime: Time.now
)

customer = User.create(
  username: 'buyer',
  password: '12345678',
  password_confirmation: '12345678'

)