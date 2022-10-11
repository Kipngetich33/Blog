# /config/test_set.rb
ENV['best_food'] = "pizza" 

# /config/environment.rb
# Load the Rails application.
require_relative 'application'

#load test_set.rb
app_test = File.join(Rails.root, 'config', 'test_env.rb')
load(app_test) if File.exist?(app_test)

# Initialize the Rails application.
Rails.application.initialize!

# .gitignore
# Ignore test_set.rb
/config/test_env.rb