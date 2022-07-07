class RecipesController < ApplicationController
  def index
    response = Contentful::RecipeService.new.perform(:recipes_list)
    @recipes = response[:data]
    respond_to do |format|
      format.html
      format.json { render json: @recipes, status: response[:status] }
    end
  end

  def show
    response = Contentful::RecipeService.new.perform(:recipe_details, params[:id])
    @recipe = response[:data]
    respond_to do |format|
      format.html
      format.json { render json: @recipe, status: response[:status] }
    end
  end
end
