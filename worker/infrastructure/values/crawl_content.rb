# frozen_string_literal: true

require 'webdrivers/chromedriver'
require 'watir'

module NoFB
  module Value
    # save the content crawled
    # :reek:TooManyInstanceVariables
    class CrawlerContent
      attr_reader :group_id, :fb_group_name, :fb_post, :fb_author, :fb_context, :fb_time

      def initialize(group_id)
        @group_id = group_id
      end

      # :reek:LongParameterList
      def save_crawl(fb_group_name, fb_post, fb_author, fb_context, fb_time)
        @fb_group_name = fb_group_name
        @fb_post = fb_post
        @fb_author = fb_author
        @fb_context = fb_context
        @fb_time = fb_time
      end
    end
  end
end
