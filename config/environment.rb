# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
RichmondTreesAdmin::Application.initialize!

Rails.logger = Logger.new(STDOUT)
Rails.logger.level = Logger::WARN

