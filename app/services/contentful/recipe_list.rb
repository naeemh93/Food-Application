# frozen_string_literal: true

module Contentful
  class RecipeList < RecipeService
    def self.recipes_list
      ApiClient.connection.entries(
        content_type: CONTENT_TYPE,
        order: '-sys.createdAt'
      ).map { |recipe| main_recipe_fields(recipe) }
    end
  end
end
