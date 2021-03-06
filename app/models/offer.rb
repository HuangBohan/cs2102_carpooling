class Offer < ActiveRecord::Base
  self.primary_keys = :datetime, :car_license_plate_number
  belongs_to :car, foreign_key: :car_license_plate_number
  has_many :requests, dependent: :destroy
  validates :datetime, presence: true
  validates :car_license_plate_number, presence: true
  validates :cost, presence: true
  validate :valid_number_of_vacancies

  def valid_number_of_vacancies
    return if vacancies.present? && vacancies > 0 && vacancies < car.seats
    errors.add(:vacancies, 'must be within the number of seats in the car')
  end

  def to_sym
    "Offer for car license number #{car_license_plate_number} on date #{datetime}"
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

  def self.search_offers(keyword, pick_up_point, drop_off_point, vancancy_lower_limit, vancancy_upper_limit, cost_lower_limit, cost_upper_limit)
    sql = "SELECT * FROM offers WHERE "\
      "(car_license_plate_number LIKE '%#{keyword}%' "\
      "OR datetime LIKE '%#{keyword}%' "\
      "OR pickUpPoint LIKE '%#{keyword}%' "\
      "OR dropOffPoint LIKE '%#{keyword}%' "\
      "OR vacancies LIKE '%#{keyword}%' "\
      "OR cost LIKE '%#{keyword}%')"
    sql = sql + "AND pickUpPoint LIKE '%#{pick_up_point}%'"
    sql = sql + "AND dropOffPoint LIKE '%#{drop_off_point}%'"
    sql = sql + "AND vacancies >= '#{vancancy_lower_limit}'" if !vancancy_lower_limit.blank?
    sql = sql + "AND vacancies <= '#{vancancy_upper_limit}'" if !vancancy_upper_limit.blank?
    sql = sql + "AND cost >= '#{cost_lower_limit}'" if !cost_lower_limit.blank?
    sql = sql + "AND cost <= '#{cost_upper_limit}'" if !cost_upper_limit.blank?
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
    return false unless datetime.present? && car_license_plate_number.present?
    return false unless car.present?
    return false unless vacancies.present? && vacancies > 0 && vacancies < car.seats
    return false if cost.blank? || cost < 0

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
    return false unless datetime.present? && car_license_plate_number.present?
    return false unless car.present?
    return false unless vacancies.present? && vacancies > 0 && vacancies < car.seats
    return false if cost.blank? || cost < 0

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

  def self.popular_pickup_points
    sql = 'SELECT o.pickUpPoint, COUNT(DISTINCT o.datetime, o.car_license_plate_number) AS num_offers, ' \
      'COUNT(DISTINCT r.offer_datetime, r.offer_car_license_plate_number, r.requester_username, r.request_datetime) AS num_requests '\
      'FROM offers o LEFT JOIN requests r ON r.offer_datetime = o.datetime AND '\
      'r.offer_car_license_plate_number = o.car_license_plate_number '\
      'GROUP BY o.pickUpPoint ORDER BY num_offers, num_requests DESC'
    ActiveRecord::Base.connection.execute(sql).each
  end

  def self.popular_dropoff_points
    sql = 'SELECT o.dropOffPoint, COUNT(DISTINCT o.datetime, o.car_license_plate_number) AS num_offers, ' \
      'COUNT(DISTINCT r.offer_datetime, r.offer_car_license_plate_number, r.requester_username, r.request_datetime) AS num_requests '\
      'FROM offers o LEFT JOIN requests r ON r.offer_datetime = o.datetime AND '\
      'r.offer_car_license_plate_number = o.car_license_plate_number '\
      'GROUP BY dropOffPoint ORDER BY num_offers, num_requests DESC'
    ActiveRecord::Base.connection.execute(sql).each
  end
end
