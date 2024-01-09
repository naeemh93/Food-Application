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
    rescue Contentful::NotFound => e
      puts e.message
    rescue StandardError => e
      puts e.message
    end
  end
end
