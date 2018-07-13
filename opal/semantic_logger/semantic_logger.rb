module SemanticLogger
  module Loggable
    def logger
      SemanticLogger.logger
    end
  end
  
  LOGGING_LEVELS = [:trace, :debug, :info, :warn, :error, :fatal]
  LOGGING_LEVELS_HASH = {
    trace: 0,
    debug: 1,
    info: 2,
    warn: 3,
    error: 4,
    fatal: 5
  }
  
  def self.default_level=(level)
  end
  
  def self.add_appender(appender)
    @appenders ||= []
    @appenders.push(appender[:appender])
  end
  
  def self.appenders
    @appenders || []
  end
  
  def self.logger
    @logger ||= Subscriber.new
    @logger
  end
  
  def self.silence(level, &block)
    levels = @appenders.map(&:level)
    begin
      @appenders.each{ |app| app.level = level }
      yield
    ensure
      @appenders.each_with_index{ |app, index| app.level = levels[index] }
    end
  end
  
  def self.[](class_name)
    logger
  end
  
  class Log
    attr_reader :message, :level, :level_index
    
    def initialize(message, level: :trace)
      @message = message
      @level = level
      @level_index = LOGGING_LEVELS_HASH[level]
    end
  end
  
  class Subscriber
    attr_reader :level, :level_index
    def initialize(level=nil, &block)
      self.level = level || :info
    end
    
    def level=(level)
      @level = level
      @level_index = LOGGING_LEVELS_HASH[@level]
    end
    
    LOGGING_LEVELS.each do |sym|
      define_method(sym) do |message, *args| 
        log_at_level(sym, message, *args)
      end
    end
    
    def log_at_level(level, message, *args)
      log(Log.new(message, level: level, level_index: LOGGING_LEVELS_HASH[level]))
    end
    
    def log(log)
      puts log.message
      SemanticLogger.appenders.each { |app| app.log(log) }
    end
    
    def include_message?(log)
      !log.message.nil?
    end
  end
end
