# frozen_string_literal: true

require 'contentful'

module Contentful
  class ApiClient
    def self.connection
      Contentful::Client.new(
        space: ENV['SPACE_KEY'],
        access_token: ENV['ACCESS_TOKEN'],
        environment: ENV['ENV_ID'],
        dynamic_entries: :auto
      )
    rescue StandardError => e
      e.class.to_s
    end
  end
end
