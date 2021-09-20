# frozen_string_literal: true

# initialze the database to have the right subclasses of scripts and projects

rails_env = ENV['RAILS_ENV']
db_cfg = Rails.configuration.database_configuration[rails_env]
db = db_cfg.nil? ? '' : db_cfg['database']

def columns_exist?
  ActiveRecord::Base.connection.column_exists?(:projects, :type) &&
    ActiveRecord::Base.connection.column_exists?(:scripts, :type)
end

if File.exist?(db) && !File.zero?(db) && columns_exist?
  Project.where(type: nil).update_all(type: 'MayaProject')
  Script.where(type: nil).update_all(type: 'MayaScript')
end
