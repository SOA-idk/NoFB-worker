# frozen_string_literal: true

require 'watir'
require 'webdrivers/chromedriver'
puts 'opening'
Webdrivers.logger.level = :debug
Watir.logger.level = :debug
browser = Watir::Browser.new :chrome#, headless: true
# browser = Watir::Browser.new(:chrome,
#   :prefs => {:password_manager_enable => false, :credentials_enable_service => false},
#   :switches => ["disable-infobars", "no-sandbox"])
puts 'opened Browser'
browser.goto('www.google.com')
puts 'goto-ed site'
browser.driver.save_screenshot('screenshot.png')
