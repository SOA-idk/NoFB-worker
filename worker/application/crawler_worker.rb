# frozen_string_literal: true

require_relative '../../init'

module NoFB
# Shoryuken worker class to clone repos in parallel
  class CrawlerWorker
    def initialize
      @config = Worker.config
      @crawler_obj = Value::WebCrawler.new # (headless: false)
      @queue = NoFB::Messaging::Queue.new(
        @config.AWS_QUEUE_URL, @config
      )
      @group_list = ['302165911402681','817620721658179']
    end

    def testDriver
      @crawler_obj.test
    end

    def testLogin
      @crawler_obj.login
    end

    def testWait
      @crawler_obj.wait_home_ready
    end

    def goAnyway
      @crawler_obj.goto_group_page('302165911402681')
    end

    # def updateDB
    #   @crawler_obj.crawl
    #   puts @crawler_obj.construct_query
    #   @crawler_obj.insert_db
    # end

    def showCrawler
      @crawler_obj.showCrawler
    end

    def read_subscibes
      word_hash = Value::GetSubscribes.get
      puts word_hash
      word_hash
    end

    def send_notify_test
      Messaging::LineNotify.notify_user(
        user_id: 'Ue98b8f412149ba518a4d07ff9aab85f3',
        fb_group_name: '沒有這個社團',
        subscribed_word: '才沒有訂閱這個字',
        fb_url: 'https://www.facebook.com/groups/302165911402681/posts/347058906913381'
      )
    end


    def loop_call
      while true
        call
        sleep 60
      end
    end

    def call
      word_hash = Value::GetSubscribes.get
      return nil if word_hash.nil?

      @group_list.each do |group_id|
        content = @crawler_obj.crawl(group_id)
        word_hash[group_id].each_key do |subscribe_word|
          content.fb_context.each_with_index do |post, idx|
            # puts "post content: #{post} vs #{subscribe_word}"
            if post.include? subscribe_word
              next unless content.fb_time[idx] == '剛剛'
              
              puts '---found---'
              puts "notify users: #{word_hash[group_id][subscribe_word]}"
              puts "notify content \"#{subscribe_word}\" at group #{content.fb_group_name}"
              puts "post content: #{post}"
              puts "idx: #{idx}"
              puts "posts: #{content.fb_post}"
              puts "post link: https://www.facebook.com/groups/#{group_id}/posts/#{content.fb_post[idx]}"
              puts '----------'

              word_hash[group_id][subscribe_word].each do |user_id|
                Messaging::LineNotify.notify_user(
                  user_id: user_id,
                  fb_group_name: content.fb_group_name,
                  subscribed_word: subscribe_word,
                  fb_url: "https://www.facebook.com/groups/#{group_id}/posts/#{content.fb_post[idx]}"
                )
              end
            end
          end
        end
      end
    end

    def keyKeep
      @crawler_obj.keyKeep
    end

    def key0
      @crawler_obj.key0
    end
    def key1
      @crawler_obj.key1
    end
    def key2
      @crawler_obj.key2
    end
    def key3
      @crawler_obj.key3
    end
    def key4
      @crawler_obj.key4
    end
    def key5
      @crawler_obj.key5
    end
    def key6
      @crawler_obj.key6
    end
    def key7
      @crawler_obj.key7
    end
    def key8
      @crawler_obj.key8
    end
    def key9
      @crawler_obj.key9
    end
    def keyEnter
      @crawler_obj.keyEnter
    end

  end
end
