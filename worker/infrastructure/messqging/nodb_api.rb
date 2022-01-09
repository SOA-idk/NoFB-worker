# frozen_string_literal: true

# require_relative 'list_request'
require 'http'

module NoFB
  module Messaging
    class API
      def self.request_all_subscribes
        url = "https://idk-nofb-api.herokuapp.com/api/v1/subscribes?access_key=#{Worker.config.ACCESS_TOKEN}"
        header = HTTP.headers('Accept' => 'application/json')

        header.send('get', url)
              .then { |http_response| Response.new(http_response) }
      end

      def self.get_user_access_token(user_id)
        url = "https://idk-nofb-api.herokuapp.com/api/v1/notify/#{user_id}?access_key=#{Worker.config.ACCESS_TOKEN}"
        header = HTTP.headers('Accept' => 'application/json')

        header.send('get', url)
              .then { |http_response| Response.new(http_response) }
      end
    end
    # Decorates HTTP responses with success/error
    class Response < SimpleDelegator
      # this is uesless descriptive comment
      NotFound = Class.new(StandardError)

      SUCCESS_CODES = (200..299)

      def success?
        code.between?(SUCCESS_CODES.first, SUCCESS_CODES.last)
      end

      def message
        json['message']
      end

      def payload
        body.to_s
      end

      def json
        JSON.parse(payload)
      end
    end
  end
end