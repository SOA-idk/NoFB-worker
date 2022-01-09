# frozen_string_literal: true

module NoFB
  module Value
    # given the ready page, get the posts and formate
    module GetSubscribes
      

      def self.get
        call_api.then do |result|
          return nil if result.nil?
          
          organize_subscribes(result)
        end
      end


      ## organize subscribes to the following hash
      # word_hash: {
      #   group_id: {
      #     word: [user_id, user_id, ...],
      #     word: [...],
      #   },
      #   group_id: {...},
      #   ...
      # }
      def self.organize_subscribes(result)
        word_hash = Hash.new()
        for sub in result.subscribes
          unless word_hash.has_key?(sub.group_id)
            word_hash[sub.group_id] = Hash.new()
          end
          words = sub.word.split(',')
          words.each do |word|
            word = word.strip.squeeze(' ')
            if word_hash[sub.group_id].has_key?(word)
              word_hash[sub.group_id][word].append(sub.user_id.to_s)
            else
              word_hash[sub.group_id][word] = Array.new
              word_hash[sub.group_id][word].append(sub.user_id.to_s)
            end
          end
        end
        word_hash
      end

      def self.call_api
        Messaging::API::request_all_subscribes.then do |result|
          if result.success?
            Representer::SubscribesList.new(OpenStruct.new)
                                       .from_json(result.payload)
          else
            puts result.message
          end
        end
      end

    end
  end
end
