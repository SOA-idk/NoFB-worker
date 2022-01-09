# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module NoFB
  module Representer
    #  Represents Group information for API output
    class UserNotify < Roar::Decorator
      include Roar::JSON

      property :user_id
      property :user_access_token
    end
  end
end
