module SemanticLogger
  module Loggable
    def logger
      SemanticLogger.logger
    end
  end
  
  LOGGING_LEVELS = [:trace, :debug, :info, :warn, :error, :fatal]
  
  def self.default_level=(level)
  end
  
  def self.add_appender(appender)
    @appenders ||= []
    @appenders.push(appender)
  end
  
  def self.logger
    @logger ||= NullLogger
  end
  
  class Base
    LOGGING_LEVELS.each do |sym|
      define_method(sym, *args) { log_at_level(sym, *args) }
    end
    
    def log_at_level(level, *args)
      
    end
  end
end