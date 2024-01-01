# frozen_string_literal: true

module Contentful
  class RecipeService
    CONTENT_TYPE = 'recipe'

    RESPONSE_TYPE = {
      success: 200,
      failure: 401,
      not_found: 404
    }.freeze

    def perform(method_name, *arguments)
      { data: send(method_name, *arguments), status: map_status(:success) }
    rescue Contentful::NotFound => e
      { data: [], status: map_status(:not_found) }
    rescue StandardError => e
      { data: [], status: map_status(:failure) }
    end

    private

    def recipes_list
      ApiClient.connection.entries(
        content_type: CONTENT_TYPE,
        order: '-sys.createdAt',
        include: 2 # Fetch related entries in a single request
      ).map { |recipe| process_recipe(recipe) }
    end

    def recipe_details(recipe_id)
      recipe = ApiClient.connection.entry(recipe_id)
      raise Contentful::NotFound if recipe.nil?

      process_recipe(recipe)
    end

    def process_recipe(recipe)
      main_recipe_fields = {
        title: recipe.fields[:title],
        image: recipe.fields[:photo]&.url_with_https # Ensure HTTPS for image URL
      }

      other_recipe_fields = {
        description: recipe.fields[:description],
        chef_name: recipe.fields[:chef]&.fields&.[](:name),
        tags_list: recipe.fields[:tags]&.map { |tag| tag.fields[:name] }
      }

      other_recipe_fields.merge(main_recipe_fields)
    end

    def map_status(response_type)
      RESPONSE_TYPE.fetch(response_type, RESPONSE_TYPE[:failure])
    end
  end
end
