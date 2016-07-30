require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDERR)

env = ENV['RT_ENV'] || 'default'
db_config = YAML.load_file('config/database.yml')[env]

ActiveRecord::Base.establish_connection(db_config)

ActiveRecord::Migrator.migrate('migrate')
