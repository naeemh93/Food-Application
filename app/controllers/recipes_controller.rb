# frozen_string_literal: true

class RecipesController < ApplicationController

  def index
    response = Contentful::RecipeService.perform(:recipes_list)
    handle_response(response)
  end

  def show
    response = Contentful::RecipeService.perform(:recipe_details, params[:id])
    handle_response(response)
  end

  private

  def handle_response(response)
    @data = response[:data]
    respond_to do |format|
      format.html
      format.json { render json: @data, status: response[:status] }
    end
  end
end
