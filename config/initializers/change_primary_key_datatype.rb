require 'active_record/connection_adapters/mysql2_adapter'
ActiveRecord::ConnectionAdapters::Mysql2Adapter::NATIVE_DATABASE_TYPES[:primary_key] = "varchar(255) COLLATE utf8_unicode_ci primary key"