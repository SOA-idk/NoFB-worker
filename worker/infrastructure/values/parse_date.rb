# frozen_string_literal: true

require 'date'

module NoFB
  module Value
    # Parse the Date
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    # :reek:TooManyStatements
    module ParseDate
      def self.parse(text)
        if text.include? '剛剛' # 最小單位: 分鐘
          ParseDate.just_now(text)
        elsif text.include? '分鐘' # 58 分鐘
          ParseDate.min_ago(text)
        elsif text.include? '小時' # 12 小時
          ParseDate.hour_ago(text)
        elsif text.include? '昨天' # 昨天下午2:43
          ParseDate.yesterday(text)
        else # 11月12日下午2:43 不考慮跨年份的日期"2020年12月31日"(應該要已經加入DB了)
          ParseDate.full_date(text)
        end
      end

      def self.full_date(text)
        text_arr = text.scan(/\d+/)
        month = text_arr[0].to_i
        date = text_arr[1].to_i
        hour = text_arr[2].to_i
        hour += 12 if text.include? '下午'
        min = text_arr[3].to_i
        thattime = DateTime.new(DateTime.now.year, month, date, hour, min, 0, '+08:00')
        "#{thattime.year}-#{thattime.month}-#{thattime.day} #{thattime.hour}:#{thattime.min}"
      end

      def self.yesterday(text)
        text_arr = text.scan(/\d+/)
        hour = text_arr[0].to_i
        hour += 12 if text.include? '下午'
        min = text_arr[1].to_i
        now = DateTime.now
        thattime = DateTime.new(now.year, now.month, now.day - 1, hour, min, 0, '+08:00')
        "#{thattime.year}-#{thattime.month}-#{thattime.day} #{thattime.hour}:#{thattime.min}"
      end

      def self.hour_ago(text)
        thattime = DateTime.now - (text.split[0].to_i / 24.0)
        "#{thattime.year}-#{thattime.month}-#{thattime.day} #{thattime.hour}:#{thattime.min}"
      end

      def self.min_ago(text)
        thattime = DateTime.now - (text.split[0].to_i / 1440.0)
        "#{thattime.year}-#{thattime.month}-#{thattime.day} #{thattime.hour}:#{thattime.min}"
      end

      def self.just_now(_text)
        thattime = DateTime.now
        "#{thattime.year}-#{thattime.month}-#{thattime.day} #{thattime.hour}:#{thattime.min}"
      end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
  end
end
