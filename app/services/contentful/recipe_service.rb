module Contentful
  class RecipeService
    CONTENT_TYPE = 'recipe'

    RESPONSE_TYPE = {
      success: 200,
      failure: 401,
      not_found: 404,
    }

    def perform(method_name, *arguments)
      begin
        { data: self.send(method_name, *arguments), status: map_status(:success) }
      rescue => e
        { data: [], status: map_status(e.message)}
      end
    end

    private

    def recipes_list
      recipes = []
      ApiClient.connection.entries(content_type: CONTENT_TYPE, order: '-sys.createdAt').each_item do |recipe|
        recipes << main_recipe_fields(recipe.fields).merge({id: recipe.id})
      end
      recipes
    end

    def recipe_details(recipe_id)
      recipe = ApiClient.connection.entry(recipe_id)

      raise 'not_found' if recipe.nil?

      other_recipe_fields(recipe.fields)
    end

    def main_recipe_fields(recipe_fields)
      main_recipe_data = {
        title: recipe_fields[:title],
        image: recipe_fields[:photo] && "https:#{recipe_fields[:photo].url}"
      }
      main_recipe_data
    end

    def other_recipe_fields(recipe_fields)
      other_recipe_data = {
        description: recipe_fields[:description],
        chef_name: recipe_fields[:chef] && recipe_fields[:chef].fields[:name],
        tags_list: recipe_fields[:tags] && recipe_fields[:tags].collect{ |tag| tag.fields[:name] }
      }
      other_recipe_data = other_recipe_data.merge(main_recipe_fields(recipe_fields))
      other_recipe_data
    end

    def map_status(response_type)
      key = RESPONSE_TYPE.has_key?(response_type.to_sym) ? response_type.to_sym : :failure
      RESPONSE_TYPE[key]
    end
  end

end
