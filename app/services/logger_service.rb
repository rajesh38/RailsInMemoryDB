class LoggerService
  def add_log(message:, log_mode:)
    case log_mode
    when "info"
      Rails.logger.info(message)
    when "debug"
      Rails.logger.debug(message)
    when "error"
      Rails.logger.error(message)
    end
  end
end