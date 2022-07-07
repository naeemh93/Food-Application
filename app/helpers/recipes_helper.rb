module RecipesHelper
  def recipe_image(recipe)
    recipe[:image].present? ? recipe[:image] : 'no-image.png'
  end
end
