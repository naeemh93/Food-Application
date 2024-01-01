# frozen_string_literal: true

class RecipesController < ApplicationController
  before_action :initialize_recipe_service, only: %i[index show]

  def index
    response = @recipe_service.perform(:recipes_list)
    handle_response(response)
  end

  def show
    response = @recipe_service.perform(:recipe_details, params[:id])
    handle_response(response)
  end

  private

  def initialize_recipe_service
    @recipe_service = Contentful::RecipeService.new
  end

  def handle_response(response)
    @data = response[:data]
    respond_to do |format|
      format.html
      format.json { render json: @data, status: response[:status] }
    end
  end
end
