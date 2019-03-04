module OregonDigital
  class Loggerly
    def self.debug(message=nil) 
      @log ||= Logger.new(Rails.root.join('log/loggerly.log'))
      @log.debug(message) unless message.nil?
    end
  end
end
