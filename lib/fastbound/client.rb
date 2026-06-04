require "faraday"
require "json"

module Fastbound
  class Client
    BASE_URL = "https://cloud.fastbound.com"

    attr_reader :account_number, :audit_user

    def initialize(api_key:, account_number:, audit_user: nil, base_url: BASE_URL)
      raise ConfigurationError, "api_key is required" if api_key.nil? || api_key.empty?
      raise ConfigurationError, "account_number is required" if account_number.nil? || account_number.empty?

      @api_key = api_key
      @account_number = account_number
      @audit_user = audit_user
      @base_url = base_url
    end

    def account
      @account ||= Resources::Account.new(self)
    end

    def acquisitions
      @acquisitions ||= Resources::Acquisitions.new(self)
    end

    def attachments
      @attachments ||= Resources::Attachments.new(self)
    end

    def contacts
      @contacts ||= Resources::Contacts.new(self)
    end

    def dispositions
      @dispositions ||= Resources::Dispositions.new(self)
    end

    def downloads
      @downloads ||= Resources::Downloads.new(self)
    end

    def form4473s
      @form4473s ||= Resources::Form4473s.new(self)
    end

    def inventory
      @inventory ||= Resources::Inventory.new(self)
    end

    def items
      @items ||= Resources::Items.new(self)
    end

    def multiple_sale_reports
      @multiple_sale_reports ||= Resources::MultipleSaleReports.new(self)
    end

    def smart_lists
      @smart_lists ||= Resources::SmartLists.new(self)
    end

    def users
      @users ||= Resources::Users.new(self)
    end

    def webhooks
      @webhooks ||= Resources::Webhooks.new(self)
    end

    def get(path, params = {})
      request(:get, path, params: compact(params))
    end

    def post(path, body = {}, audit: true)
      request(:post, path, body: body, audit: audit)
    end

    def put(path, body = {}, audit: true)
      request(:put, path, body: body, audit: audit)
    end

    def delete(path, audit: true)
      request(:delete, path, audit: audit)
    end

    def get_binary(path)
      response = connection.get(path)
      handle_response(response, raw: true)
    end

    def post_binary(path, body = {}, audit: true)
      response = connection(audit: audit).post(path) do |req|
        req.body = body.to_json
        req.headers["Content-Type"] = "application/json"
      end
      handle_response(response, raw: true)
    end

    def base_path
      "/#{account_number}/api"
    end

    private

    def request(method, path, params: nil, body: nil, audit: false)
      response = connection(audit: audit).public_send(method, path) do |req|
        req.params = params if params&.any?
        if body
          req.body = body.to_json
          req.headers["Content-Type"] = "application/json"
        end
      end
      handle_response(response)
    end

    def handle_response(response, raw: false)
      case response.status
      when 200, 201
        return response.body if raw
        response.body.empty? ? nil : JSON.parse(response.body)
      when 204
        nil
      when 401, 403
        raise UnauthorizedError.new(response.status, safe_parse(response.body))
      when 404
        raise NotFoundError.new(response.status, safe_parse(response.body))
      when 400, 422
        raise UnprocessableEntityError.new(response.status, safe_parse(response.body))
      else
        raise ApiError.new(response.status, safe_parse(response.body))
      end
    end

    def safe_parse(body)
      JSON.parse(body)
    rescue StandardError
      {}
    end

    def compact(hash)
      hash.reject { |_, v| v.nil? }
    end

    def connection(audit: false)
      Faraday.new(url: @base_url) do |conn|
        conn.request :authorization, :basic, @api_key, ""
        conn.headers["Accept"] = "application/json"
        conn.headers["X-AuditUser"] = @audit_user if audit && @audit_user
      end
    end
  end
end
