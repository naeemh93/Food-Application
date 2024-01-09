# frozen_string_literal: true

module Contentful
  class RecipeService
    CONTENT_TYPE = 'recipe'

    RESPONSE_TYPE = {
      success: 200,
      api_error: 401,
      not_found: 404
    }.freeze

    def self.call(method_name, *arguments)
      case method_name
      when :recipes_list
        RecipeList.recipes_list
      when :recipe_details
        RecipeDetails.recipe_details(*arguments)
      else
        raise ArgumentError, "Invalid method name: #{method_name}"
      end
    rescue Contentful::NotFound => e
      { data: [], status: map_status(e.message) }
    rescue StandardError => e
      { data: [], status: map_status(e.message) }
    end

    def self.main_recipe_fields(recipe_fields)
      {
        title: recipe_fields[:title],
        image: recipe_fields[:photo]&.url
      }
    end

    def self.extended_recipe_fields(recipe_fields)
      {
        description: recipe_fields[:description],
        chef_name: recipe_fields[:chef]&.fields&.dig(:name),
        tags_list: recipe_fields[:tags]&.map { |tag| tag.fields[:name] }
      }.merge(main_recipe_fields(recipe_fields))
    end

    def self.map_status(response_type)
      RESPONSE_TYPE.fetch(response_type.to_sym, RESPONSE_TYPE[:api_error])
    end
  end
end
