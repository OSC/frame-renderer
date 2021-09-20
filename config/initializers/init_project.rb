# rails 5.2 update where we need to migrate from using t/f to 1/0 because that's
# the new default.
require "active_record/connection_adapters/sqlite3_adapter"
ActiveRecord::ConnectionAdapters::SQLite3Adapter.represent_boolean_as_integer = true

rails_env = ENV['RAILS_ENV']
db_cfg = Rails.configuration.database_configuration[rails_env]
db = db_cfg.nil? ? "" : db_cfg["database"]

# if File.exist?(db) && !File.zero?(db)
#   Project.where("project_type = ''").update_all(project_type: 'maya');
# end
