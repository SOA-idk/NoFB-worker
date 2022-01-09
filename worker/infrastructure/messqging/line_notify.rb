# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'jwt'

module NoFB
  module Messaging
    class LineNotify
      def self.get_user_access_token(user_id)
        Messaging::API::get_user_access_token(user_id).then do |result|
          if result.success?
            Representer::UserNotify.new(OpenStruct.new)
                                   .from_json(result.payload).user_access_token
          else
            puts "\"#{user_id}\" #{result.message}"
          end
        end
      end

      def self.notify_user(input)
        user_access_token = get_user_access_token(input[:user_id])
        return nil if user_access_token.nil?

        uri = URI('https://notify-api.line.me/api/notify')
        header = { 'Authorization' => "Bearer #{user_access_token}",
                  'Content-Type' => 'application/x-www-form-urlencoded' }
        data = {
          'message': "你在「#{input[:fb_group_name]}」社團所訂閱的「#{input[:subscribed_word]}」已發現!!!\n趕快前往查看╰(*°▽°*)╯\n#{input[:fb_url]}"
        }
        puts data[:message]

        data = URI.encode_www_form(data)

        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true # secure sockets layer, protect sensitive data from modification

        response = https.post(uri, data, header)
        if response.is_a?(Net::HTTPSuccess)
          body = JSON.parse response.body
          puts body['status']
        else
          puts 'LINE NOTIFY FAILED TO GET TOKEN'
        end
      end
    end
  end
end
