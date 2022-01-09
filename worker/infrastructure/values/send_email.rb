# frozen_string_literal: true

require 'rest-client'

module NoFB
  module Value
    # send email
    module SendEmail
      def self.send_test_mail
        domain_name = ENV['MAILGUN_DOMAIN_NAME']
        api_key = ENV['MAILGUN_API_KEY']
        send_url = "https://api:#{api_key}@api.mailgun.net/v3/#{domain_name}/messages"
        RestClient.post send_url,
                        from: 'idk-nofb <admin@idk-nofb.com>',
                        to: 'hhoracehsu@gmail.com',
                        subject: 'Subscribed Words Notification',
                        text: 'Testing some Mailgun awesomness!'
      end
    end
  end
end
