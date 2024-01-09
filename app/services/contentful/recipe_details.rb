# frozen_string_literal: true

module Contentful
  class RecipeDetails < RecipeService
    def self.recipe_details(recipe_id)
      recipe = ApiClient.connection.entry(recipe_id)
      raise Contentful::NotFound if recipe.nil?

      extended_recipe_fields(recipe)
    end
  end
end
