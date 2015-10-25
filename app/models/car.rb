class Car < ActiveRecord::Base
  self.primary_key = 'license_plate_number'
  belongs_to :owner, class_name: :User, foreign_key: :owner_username
  has_many :offers, dependent: :destroy
  validate :at_least_one_seat

  def at_least_one_seat
    return if seats > 0
    errors.add(:offer, 'must have at least one seat')
  end

  def self.get_car(license_plate_number)
    sql = "SELECT * FROM cars WHERE license_plate_number='#{license_plate_number}'"
    Car.find_by_sql(sql).first
  end

  def self.get_user_cars(username)
    sql = "SELECT * FROM cars WHERE owner_username='#{username}'"
    Car.find_by_sql(sql)
  end

  def self.new_car(params)
    name = params[:name]
    license_plate_number = params[:license_plate_number]
    owner_username = params[:owner_username]
    seats = params[:seats].to_i

    raise ActiveRecord::ActiveRecordError if seats <= 0

    sql = "INSERT INTO cars "\
      "(owner_username, name, license_plate_number, seats) "\
      "VALUES ('#{owner_username}', '#{name}', '#{license_plate_number}', '#{seats}');"
    ActiveRecord::Base.connection.execute sql

    license_plate_number
  end

  def self.update_car(params, license_plate_number)
    name = params[:name]
    seats = params[:seats].to_i

    return false if seats <= 0

    sql = "UPDATE cars "\
      "SET name='#{name}', seats='#{seats}' "\
      "WHERE license_plate_number='#{license_plate_number}';"

    ActiveRecord::Base.connection.execute sql
    true
  end

  def self.destroy_car(license_plate_number)
    sql = "DELETE FROM cars "\
      "WHERE license_plate_number='#{license_plate_number}';"
    ActiveRecord::Base.connection.execute sql
    true
  end
end
