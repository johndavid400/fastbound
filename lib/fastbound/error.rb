module Fastbound
  class Error < StandardError; end
  class ConfigurationError < Error; end

  class ApiError < Error
    attr_reader :status, :errors

    def initialize(status, body)
      @status = status
      @errors = parse_errors(body)
      super(build_message)
    end

    private

    def parse_errors(body)
      return [] unless body.is_a?(Hash)

      Array(body["errors"]).map { |e| e.is_a?(Hash) ? e["message"] : e.to_s }.compact
    end

    def build_message
      base = "HTTP #{status}"
      errors.any? ? "#{base}: #{errors.join(", ")}" : base
    end
  end

  class NotFoundError < ApiError; end
  class UnprocessableEntityError < ApiError; end
  class UnauthorizedError < ApiError; end
end
