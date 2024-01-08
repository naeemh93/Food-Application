# frozen_string_literal: true

module Contentful
  class RecipeService
    CONTENT_TYPE = 'recipe'

    RESPONSE_TYPE = {
      success: 200,
      api_error: 401,
      not_found: 404
    }.freeze

    def self.perform(method_name, *arguments)
      { data: send(method_name, *arguments), status: map_status(:success) }
    rescue Contentful::NotFound => e
      { data: [], status: map_status(e.message) }
    rescue StandardError => e
      { data: [], status: map_status(e.message) }
    end

    private

    def recipes_list
      ApiClient.connection.entries(
        content_type: CONTENT_TYPE,
        order: '-sys.createdAt'
      ).map { |recipe| main_recipe_fields(recipe) }
    end

    def recipe_details(recipe_id)
      recipe = ApiClient.connection.entry(recipe_id)
      raise Contentful::NotFound if recipe.nil?

      extended_recipe_fields(recipe)
    end

    def main_recipe_fields(recipe_fields)
      {
        title: recipe_fields[:title],
        image: recipe_fields[:photo]&.url
      }
    end

    def extended_recipe_fields(recipe_fields)
      {
        description: recipe_fields[:description],
        chef_name: recipe_fields[:chef]&.fields&.dig(:name),
        tags_list: recipe_fields[:tags]&.map { |tag| tag.fields[:name] }
      }.merge(main_recipe_fields(recipe_fields))
    end

    def map_status(response_type)
      RESPONSE_TYPE.fetch(response_type.to_sym, RESPONSE_TYPE[:api_error])
    end
  end
end
