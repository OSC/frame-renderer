# rails 5.2 update where we need to migrate from using t/f to 1/0 because that's
# the new default.


require "active_record/connection_adapters/sqlite3_adapter"
ActiveRecord::ConnectionAdapters::SQLite3Adapter.represent_boolean_as_integer = true

Script.where("email = 't'").update_all(email: 1)
Script.where("email = 'f'").update_all(email: 0)

Script.where("skip_existing = 't'").update_all(skip_existing: 1)
Script.where("skip_existing = 'f'").update_all(skip_existing: 0)
