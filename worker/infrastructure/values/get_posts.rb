# frozen_string_literal: true

module NoFB
  module Value
    # given the ready page, get the posts and formate
    module GetPosts
      def self.get_group_name(browser)
        browser.h1.text
      end

      def self.get_articles(browser)
        articles = browser.elements(xpath: '//section/article//p')
        articles.map(&:text)
      end

      def self.get_authors(browser)
        authors = browser.elements(xpath: '//section/article//strong')
        authors.map(&:text)
      end

      def self.get_times(browser)
        times = browser.elements(xpath: '//section/article//abbr')
        times.map do |item|
          item = item.text
          item
          # ParseDate.parse(item)
        end
      end

      def self.get_post_ids(browser)
        # post_ids = browser.elements(xpath: '//a[contains(text(), "讚")]')
        post_ids = browser.elements(xpath: '//section/article')
        post_ids.map do |item|
          JSON.parse(item.attribute_value('data-ft'))['mf_story_key']
        end
      end
    end
  end
end
