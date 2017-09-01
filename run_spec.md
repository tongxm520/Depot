##rake db:migrate RAILS_ENV=test
##rails s -e test

>rake test:units
>rake test:functionals
>ruby -Itest test/unit/product_test.rb
>ruby -Itest test/unit/product_test.rb -n product_attributes_must_not_be_empty
>ruby -Itest test/unit/product_test.rb -n /attributes/

##rake spec
##rspec spec/models/product_spec.rb


##rake db:create RAILS_ENV=production
##rails s -e production 
##bundle exec rake assets:precompile RAILS_ENV=production


For Rails 3.x, configure a logger in config/environments/test.rb:
config.logger = Logger.new(STDOUT)
config.logger.level = Logger::ERROR

This will interleave any errors that are logged during testing to STDOUT. You may wish to route the output to *STDERR* or use a different log level instead.

Sending these messages to both the console and a log file requires something more robust than Ruby's built-in Logger class. The **logging** gem will do what you want. Add it to your Gemfile, then set up two appenders in config/environments/test.rb:

logger = Logging.logger['test']
logger.add_appenders(
    Logging.appenders.stdout,
    Logging.appenders.file('example.log')
)
logger.level = :info
config.logger = logger
-----------------------------------------------------------



