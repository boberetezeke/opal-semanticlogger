if RUBY_ENGINE == "opal"
  require 'opal-rspec'
  require 'opal-semanticlogger'
else
  $:.insert(0, "opal")
  require("semantic_logger")
end

require 'semantic_logger'

RSpec.configure do |config|
end

