# frozen_string_literal: true

require 'webdrivers/chromedriver'
require 'watir'

module NoFB
  module Value
    # new a browser and login facebook with given account
    # rubocop:disable Metrics/AbcSize
    class WebCrawler
      attr_reader :browser, :content

      def initialize(headless: true)
        Webdrivers.logger.level = :debug
        Watir.logger.level = :debug
        @browser = if headless
                     Watir::Browser.new :chrome, headless: true
                   else
                     Watir::Browser.new :chrome
                   end
        # , options: {prefs: {'intl' => {'accept_languages' => 'en'}}}
      end

      def test
        puts 'opened Browser'
        browser.goto('www.google.com')
        puts 'goto-ed site'
        # browser.driver.save_screenshot('./worker/infrastructure/values/screenshots/screenshot0.png')
      end

      def login
        browser.goto 'https://www.facebook.com/login'
        # browser.driver.save_screenshot('./worker/infrastructure/values/screenshots/screenshot0.png')
        browser.text_field(id: 'email').set(ENV['FB_USERNAME'])
        browser.text_field(id: 'pass').set(ENV['FB_PASSWORD'])
        # browser.driver.save_screenshot('./worker/infrastructure/values/screenshots/screenshot1.png')
        browser.button(id: 'loginbutton').click
      end

      def wait_home_ready
        # browser.driver.save_screenshot('./worker/infrastructure/values/screenshots/screenshot0.png')
        Watir::Wait.until(timeout: 5) do
          browser.svg(class: 'fzdkajry').present?
        end
      end

      def goto_group_page(group_id)
        browser.goto "https://mbasic.facebook.com/groups/#{group_id}"
        # browser.driver.save_screenshot('./worker/infrastructure/values/screenshots/screenshot0.png')
        wait_page_ready
      end

      def wait_page_ready
        # browser.driver.save_screenshot('./worker/infrastructure/values/screenshots/screenshot2.png')
        Watir::Wait.until(timeout: 5) do
          browser.h1.present?
        end
        # browser.driver.save_screenshot('./worker/infrastructure/values/screenshots/screenshot3.png')
        puts 'group page ready'
      end

      def crawl(group_id)
        goto_group_page(group_id)

        content = CrawlerContent.new(group_id)
        content.save_crawl(
          GetPosts.get_group_name(browser),
          GetPosts.get_post_ids(browser),
          nil,# GetPosts.get_authors(browser),
          GetPosts.get_articles(browser),
          GetPosts.get_times(browser)
        )
        puts 'crawl done'
        content
      end

      # un-used
      # :reek:TooManyStatements
      def construct_query
        fb_post = content.fb_post
        querys = 'INSERT INTO posts VALUES '
        fb_post.each_with_index do |id, idx|
          querys += "(#{id}, #{content.group_id}, #{content.fb_author[idx * 2]}, "
          querys += "#{content.fb_context[idx]}, #{content.fb_time[idx]})"
          querys += ', ' if idx != fb_post.length - 1
        end
        "#{querys};"
      end

      def insert_db
        content.fb_post.each_with_index do |id, idx|
          post = Entity::Post.new(
            post_id: id.to_s,
            group_id: content.group_id.to_s,
            user_name: content.fb_author[idx * 2].to_s,
            message: content.fb_context[idx].to_s,
            updated_time: content.fb_time[idx].to_s
          )
          NoFB::Repository::Post.db_find_or_create(post, content.fb_group_name)
        end
      end
    end
    # rubocop:enable Metrics/AbcSize
  end
end
