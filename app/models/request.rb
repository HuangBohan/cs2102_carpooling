class Request < ActiveRecord::Base
  self.primary_keys = :offer_datetime, :offer_car_license_plate_number, :requester_username
  belongs_to :requester, class_name: :User, foreign_key: :requester_username
  belongs_to :offer, foreign_key: [:offer_datetime, :offer_car_license_plate_number]

  def self.get_request(offer_datetime, offer_car_license_plate_number, requester_username)
    sql = "SELECT * FROM requests WHERE offer_datetime='#{offer_datetime}' AND "\
      "requester_username='#{requester_username}' AND "\
      "offer_car_license_plate_number='#{offer_car_license_plate_number}';"
    Request.find_by_sql(sql).first
  end

  def self.get_offer_requests(offer_datetime, offer_car_license_plate_number)
    sql = "SELECT * FROM requests WHERE offer_datetime='#{offer_datetime}' AND "\
      "offer_car_license_plate_number='#{offer_car_license_plate_number}';"
    Request.find_by_sql(sql)
  end

  def self.get_taken_offer_request(offer_datetime, offer_car_license_plate_number)
    sql = "SELECT * FROM requests WHERE offer_datetime='#{offer_datetime}' AND "\
      "offer_car_license_plate_number='#{offer_car_license_plate_number}' AND status = 1;"
    Request.find_by_sql(sql).first
  end


  def self.new_request(params)
    offer_car_license_plate_number = params[:offer_car_license_plate_number]
    offer_datetime = params[:offer_datetime]
    requester_username = params[:requester_username]

    offer = Offer.get_offer(offer_datetime, offer_car_license_plate_number)
    return false unless offer.present?
    requester = User.get_user(requester_username)
    return false unless requester.present?

    sql = "INSERT INTO requests "\
      "(offer_car_license_plate_number, offer_datetime, requester_username) "\
      "VALUES ('#{offer_car_license_plate_number}', '#{offer_datetime}', '#{requester_username}');"
    ActiveRecord::Base.connection.execute sql

    [offer_datetime, offer_car_license_plate_number, requester_username]
  end

  def self.approve_request(offer_datetime, offer_car_license_plate_number, requester_username)
    offer = Offer.get_offer(offer_datetime, offer_car_license_plate_number)
    return false unless offer.present?
    requester = User.get_user(requester_username)
    return false unless requester.present?
    car = Car.get_car(offer.car_license_plate_number)
    owner = User.get_user(car.owner_username)

    sql1 = "UPDATE requests "\
      "SET status=1 "\
      "WHERE offer_datetime='#{offer_datetime}' AND "\
      "requester_username='#{requester_username}' AND "\
      "offer_car_license_plate_number='#{offer_car_license_plate_number}';"
    ActiveRecord::Base.connection.execute sql1

    sql2 = "UPDATE users "\
      "SET credits = credits - #{offer.cost.to_i} "\
      "WHERE users.username='#{requester_username}';"
    ActiveRecord::Base.connection.execute sql2

    sql3 = "UPDATE users u SET credits = credits + #{offer.cost.to_i} "\
      "WHERE EXISTS (SELECT * FROM cars c INNER JOIN offers o ON o.car_license_plate_number = c.license_plate_number "\
      "WHERE c.owner_username = u.username AND c.license_plate_number = '#{offer.car_license_plate_number}');"
    ActiveRecord::Base.connection.execute sql3
  end
end
