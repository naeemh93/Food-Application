# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipesController do
  subject { Contentful::RecipeService.new }

  describe '#index' do
    let(:params) { { format: 'json' } }

    context 'request is successfull' do
      before do
        allow(subject).to receive(:recipes_list) { -> { true } }
      end

      it 'responds with 200 status code' do
        get :index, params
        expect(response.status).to eq 200
      end

      it 'return recipes list' do
        get :index, params

        json_response = JSON.parse(response.body)
        expect(json_response.class).to eq Array
        expect(json_response.first.keys).to match_array(%w[id title image])
      end
    end

    context 'request is not successful;' do
      before do
        Contentful::RecipeService.any_instance.stub(:recipes_list) { raise ArgumentError, 'test error' }
      end

      it 'responds with 401 status code' do
        get :index, params
        expect(response.status).to eq 401
      end
    end
  end

  describe '#show' do
    let(:params) do
      { id: subject.perform(:recipes_list)[:data].first[:id], format: 'json' }
    end

    context 'request is successfull' do
      before do
        allow(Contentful::RecipeService.new).to receive(:recipe_details) { -> { true } }
      end

      it 'responds with 200 status code' do
        get :show, params: params
        expect(response.status).to eq 200
      end

      it 'return recipe detail attributes' do
        get :show, params: params
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to match_array(%w[title description chef_name tags_list image])
      end
    end

    context 'request is not successfull with invalid id' do
      before do
        allow(subject).to receive(:recipe_details) { -> { true } }
      end

      it 'responds with 404 status code' do
        get :show, params: { id: 1, format: 'json' }
        expect(response.status).to eq 404
      end
    end

    context 'request is not successfull' do
      before do
        Contentful::RecipeService.any_instance.stub(:recipe_details) { raise ArgumentError, 'test error' }
      end

      it 'responds with 401 status code' do
        get :show, params: params
        expect(response.status).to eq 401
      end
    end
  end
end
