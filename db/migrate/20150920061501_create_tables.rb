class CreateTables < ActiveRecord::Migration
  def change

    execute <<-SQL
      CREATE TABLE `users` (
        `username` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
        `isAdmin` tinyint(1) DEFAULT NULL,
        `credits` int(11) DEFAULT 50,
        `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
        `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `reset_password_sent_at` datetime DEFAULT NULL,
        `remember_created_at` datetime DEFAULT NULL,
        `sign_in_count` int(11) NOT NULL DEFAULT '0',
        `current_sign_in_at` datetime DEFAULT NULL,
        `last_sign_in_at` datetime DEFAULT NULL,
        `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        PRIMARY KEY (`username`),
        UNIQUE KEY `index_users_on_username` (`username`),
        UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
    SQL

    execute <<-SQL
      CREATE TABLE `cars` (
        `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `seats` int(11) DEFAULT NULL,
        `owner_username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
        `license_plate_number` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
        FOREIGN KEY (`owner_username`) REFERENCES `users`(`username`)
        ON DELETE CASCADE ON UPDATE CASCADE,
        PRIMARY KEY (`license_plate_number`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
      SQL

    execute <<-SQL
      CREATE TABLE `offers` (
        `datetime` datetime NOT NULL DEFAULT NOW(),
        `pickUpPoint` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `dropOffPoint` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
        `cost` int(11) DEFAULT 0,
        `vacancies` int(11) DEFAULT NULL,
        `car_license_plate_number` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
        PRIMARY KEY (`datetime`, `car_license_plate_number`),
        FOREIGN KEY (`car_license_plate_number`) REFERENCES `cars`(`license_plate_number`)
        ON DELETE CASCADE ON UPDATE CASCADE,
        KEY `index_offers_on_car_license_plate_number` (`car_license_plate_number`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
    SQL

    execute <<-SQL
      CREATE TABLE `requests` (
        `requester_username` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
        `status` tinyint(1) DEFAULT NULL,
        `offer_datetime` datetime NOT NULL DEFAULT NOW(),
        `offer_car_license_plate_number` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
        `request_datetime` datetime NOT NULL DEFAULT NOW(),
        PRIMARY KEY (`requester_username`, `offer_datetime`, `offer_car_license_plate_number`, `request_datetime`),
        FOREIGN KEY (`requester_username`) REFERENCES `users`(`username`)
        ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (`offer_car_license_plate_number`)
        REFERENCES `offers`(`car_license_plate_number`)
        ON DELETE CASCADE ON UPDATE CASCADE,
        KEY `index_requests_on_offer_details` (`offer_datetime`, `offer_car_license_plate_number`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
    SQL
  end
end
