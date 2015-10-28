class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  self.primary_key = 'username'
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :cars, dependent: :destroy

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def self.new_user(params)
    username = ActiveRecord::Base::sanitize(params[:username])
    password = ActiveRecord::Base::sanitize(params[:password])
    isAdmin = ActiveRecord::Base::sanitize(params[:isAdmin])
    sql = "INSERT INTO users (username, password, isAdmin) VALUES (#{username}, #{password}, #{isAdmin});"
    ActiveRecord::Base.connection.execute sql
    params[:username]
  end

  def self.get_user(username)
    sql = "SELECT * FROM users WHERE username='#{username}'"
    User.find_by_sql(sql)
  end

  def self.search_user(username)
    sql = "SELECT * FROM users WHERE username LIKE '%#{username}%'"
    User.find_by_sql(sql)
  end

  def self.user_offers_report
    sql = 'SELECT username, COUNT(DISTINCT c.license_plate_number) AS num_cars, COUNT(DISTINCT o.datetime, o.car_license_plate_number) AS num_offers, '\
      'COUNT(DISTINCT r.offer_datetime, r.offer_car_license_plate_number, r.requester_username) AS num_requests, '\
      'CONCAT(ROUND(IF(COUNT(DISTINCT r.offer_datetime, r.offer_car_license_plate_number, r.requester_username)=0,0, '\
      '( COUNT(DISTINCT o.datetime, o.car_license_plate_number)/COUNT(DISTINCT c.license_plate_number) * 100 )),2),"%") '\
      'AS car_offered_percentage, CONCAT(ROUND(IF(COUNT(DISTINCT o.datetime, o.car_license_plate_number)=0, 0, '\
      'COUNT(DISTINCT r.offer_datetime, r.offer_car_license_plate_number, r.requester_username)/COUNT(DISTINCT o.datetime, o.car_license_plate_number)) * 100, 2), "%") '\
      'AS offers_requested_percentage FROM users u LEFT JOIN cars c on c.owner_username = u.username '\
      'LEFT JOIN offers o ON o.car_license_plate_number = c.license_plate_number LEFT JOIN requests r '\
      'ON r.offer_datetime = o.datetime AND r.offer_car_license_plate_number = o.car_license_plate_number GROUP BY u.username'
    ActiveRecord::Base.connection.execute(sql).each
  end
end
