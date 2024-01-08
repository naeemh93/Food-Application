# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipesController do

  describe '#index' do
    let(:params) { { format: 'json' } }

    context 'when the request is successful' do
      before do
        allow(Contentful::RecipeService).to receive(:recipes_list) { [double(id: 1, title: 'Recipe 1', image: 'image.jpg')] }
      end

      it 'responds with a 200 status code' do
        get :index, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns a list of recipes with expected attributes' do
        get :index, params: params
        json_response = JSON.parse(response.body)
        expect(json_response).to match_array([{ 'id' => 1, 'title' => 'Recipe 1', 'image' => 'image.jpg' }])
      end
    end

    context 'when the request is not successful' do
      before do
        allow(Contentful::RecipeService).to receive(:recipes_list).and_raise(ArgumentError, 'request not successful')
      end

      it 'responds with a 401 status code' do
        get :index, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe '#show' do
    let(:recipe) { create(:recipe) }
    let(:params) { { id: recipe.id, format: 'json' } }

    context 'when the request is successful' do
      before do
        allow(Contentful::RecipeService).to receive(:recipe_details).with(recipe.id) { recipe }
      end

      it 'responds with a 200 status code' do
        get :show, params: params
        expect(response).to have_http_status(:ok)
      end

      it 'returns the recipe with expected attributes' do
        get :show, params: params
        json_response = JSON.parse(response.body)
        expect(json_response).to include('title' => recipe.title, 'description' => recipe.description,
                                         'chef_name' => recipe.chef_name, 'tags_list' => recipe.tags_list,
                                         'image' => recipe.image)
      end
    end

    context 'when the request is not successful with an invalid ID' do
      it 'responds with a 404 status code' do
        get :show, params: { id: 1, format: 'json' }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the request is not successful' do
      before do
        allow(Contentful::RecipeService).to receive(:recipe_details).and_raise(ArgumentError, 'test error')
      end

      it 'responds with a 401 status code' do
        get :show, params: params
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
