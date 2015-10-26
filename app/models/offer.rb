class Offer < ActiveRecord::Base
  self.primary_keys = :datetime, :car_license_plate_number
  belongs_to :car, foreign_key: :car_license_plate_number
  has_many :requests, dependent: :destroy

  validate :valid_number_of_vacancies

  def valid_number_of_vacancies
    return if vacancies > 0 && vacancies < car.seats
    errors.add(:vacancies, 'must be within the number of seats in the car')
  end

  def to_sym
    "#{license_plate_number} | #{datetime}"
  end

  def self.get_offer(datetime, car_license_plate_number)
    sql = "SELECT * FROM offers WHERE car_license_plate_number='#{car_license_plate_number} '"\
      "AND datetime='#{datetime}'"
    Offer.find_by_sql(sql).first
  end

  def self.get_all_offers
    sql = "SELECT * FROM offers"
    Offer.find_by_sql(sql)
  end

  def self.search_offers(keyword)
    sql = "SELECT * FROM offers WHERE "\
      "car_license_plate_number LIKE '%#{keyword}%' "\
      "OR datetime LIKE '%#{keyword}%' "\
      "OR pickUpPoint LIKE '%#{keyword}%' "\
      "OR dropOffPoint LIKE '%#{keyword}%' "\
      "OR vacancies LIKE '%#{keyword}%' "\
      "OR cost LIKE '%#{keyword}%'"
    Offer.find_by_sql(sql)
  end

  def self.new_offer(params)
    car_license_plate_number = params[:car_license_plate_number]
    datetime = params["datetime(1i)"] + "-" + params["datetime(2i)"] + "-" + params["datetime(3i)"] + "-" + params["datetime(4i)"]+":"+params["datetime(5i)"]
    pickUpPoint = params[:pickUpPoint]
    dropOffPoint = params[:dropOffPoint]
    vacancies = params[:vacancies].to_i
    cost = params[:cost].to_i

    car = Car.get_car(car_license_plate_number)
    raise ActiveRecord::ActiveRecordError unless car.present?
    raise ActiveRecord::ActiveRecordError unless vacancies > 0 && vacancies < car.seats
    raise ActiveRecord::ActiveRecordError if cost < 0

    sql = "INSERT INTO offers "\
      "(car_license_plate_number, datetime, pickUpPoint, dropOffPoint, vacancies, cost) "\
      "VALUES ('#{car_license_plate_number}', '#{datetime}', '#{pickUpPoint}', '#{dropOffPoint}', '#{vacancies}', '#{cost}');"
    ActiveRecord::Base.connection.execute sql

    [datetime, car_license_plate_number]
  end

  def self.update_offer(params, datetime, car_license_plate_number)
    pickUpPoint = params[:pickUpPoint]
    dropOffPoint = params[:dropOffPoint]
    vacancies = params[:vacancies].to_i
    cost = params[:cost].to_i

    car = Car.get_car(car_license_plate_number)
    raise ActiveRecord::ActiveRecordError unless vacancies > 0 && vacancies < car.seats
    raise ActiveRecord::ActiveRecordError if cost < 0

    sql = "UPDATE offers "\
      "SET pickUpPoint='#{pickUpPoint}', dropOffPoint='#{dropOffPoint}', "\
      "vacancies='#{vacancies}', cost='#{cost}' "\
      "WHERE datetime='#{datetime}' AND car_license_plate_number='#{car_license_plate_number}';"

    ActiveRecord::Base.connection.execute sql
    true
  end

  def self.destroy_offer(datetime, car_license_plate_number)
    sql = "DELETE FROM offers "\
      "WHERE datetime='#{datetime}' AND car_license_plate_number='#{car_license_plate_number}';"
    ActiveRecord::Base.connection.execute sql
    true
  end
end
